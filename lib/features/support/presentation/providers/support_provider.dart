import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/models/support_model.dart';
import '../../../../core/utils/firestore_helpers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Provider for user's support tickets
final userTicketsProvider = StreamProvider.autoDispose<List<SupportTicket>>((
  ref,
) {
  // Watch auth state to automatically refresh when user signs in/out
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) return Stream.value([]);

  // Simplified query without orderBy to avoid needing composite index
  return FirebaseFirestore.instance
      .collection('support_tickets')
      .where('userId', isEqualTo: user.id)
      .snapshots()
      .map((snapshot) {
        final tickets = snapshot.docs.map((doc) {
          final data = FirestoreHelpers.convertTimestamps({
            ...doc.data(),
            'id': doc.id,
          });
          return SupportTicket.fromJson(data);
        }).toList();
        // Sort client-side
        tickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return tickets;
      })
      .handleError((error) {
        // Return empty list on error
        return <SupportTicket>[];
      });
});

/// Provider for ticket messages
final ticketMessagesProvider =
    StreamProvider.family<List<TicketMessage>, String>((ref, ticketId) {
      return FirebaseFirestore.instance
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              final data = FirestoreHelpers.convertTimestamps({
                ...doc.data(),
                'id': doc.id,
              });
              return TicketMessage.fromJson(data);
            }).toList(),
          );
    });

/// Default FAQ items when Firestore collection is empty
List<FAQItem> _getDefaultFAQs() {
  return [
    FAQItem(
      id: 'faq_1',
      question: 'How do I book a ride?',
      answer:
          'Browse available trips and create a payment-required booking request. Seats, confirmation, and direct chat unlock only after payment is verified by the server.',
      category: 'Booking',
    ),
    FAQItem(
      id: 'faq_2',
      question: 'How do payments work?',
      answer:
          'Payments are disabled in the Build Week judge build. The app still keeps the business logic clear: riders and package senders are the paying side, and drivers or couriers are the receiving side. Real cards, escrow, refunds, and bank payouts require a separate compliant payment integration before launch.',
      category: 'Payments',
    ),
    FAQItem(
      id: 'faq_3',
      question: 'How do I become a driver?',
      answer:
          'Open Verification and complete manual identity, selfie, driver license, and vehicle registration review. Offer Ride stays locked until those driver requirements are approved.',
      category: 'Drivers',
    ),
    FAQItem(
      id: 'faq_4',
      question: 'What if I need to cancel?',
      answer:
          'Self-service cancellation is allowed before the scheduled departure. The confirmed chat closes after cancellation. Emergency or post-departure issues should be escalated to support.',
      category: 'Booking',
    ),
    FAQItem(
      id: 'faq_5',
      question: 'How do I contact support?',
      answer:
          'Start one conversation from Contact Support. GPT-5.6 answers first; use “Need a person?” whenever the answer is not enough or an account-specific action is required.',
      category: 'Support',
    ),
  ];
}

/// Provider for FAQ items
final faqProvider = FutureProvider<List<FAQItem>>((ref) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('faq').get();

    if (snapshot.docs.isEmpty) {
      return _getDefaultFAQs();
    }

    final faqs = snapshot.docs
        .map((doc) => FAQItem.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    // Sort by category client-side
    faqs.sort((a, b) => a.category.compareTo(b.category));
    return faqs;
  } catch (e) {
    // Return default FAQs on error
    return _getDefaultFAQs();
  }
});

/// Create support ticket
Future<SupportTicket> createTicket({
  required TicketCategory category,
  required String subject,
  required String description,
  String? tripId,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('contactSupport')
        .call({
          'schemaVersion': 1,
          'category': category.name,
          'subject': subject,
          'message': description,
          'tripId': tripId,
        });
    final data = Map<String, dynamic>.from(result.data as Map);
    final ticketId = data['ticketId'];
    if (ticketId is! String || ticketId.isEmpty) {
      throw Exception('Support did not return a ticket ID.');
    }
    return SupportTicket(
      id: ticketId,
      userId: user.uid,
      tripId: tripId,
      category: category,
      status: data['escalated'] == true
          ? TicketStatus.inProgress
          : TicketStatus.open,
      subject: subject.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  } on FirebaseFunctionsException catch (error) {
    throw Exception(error.message ?? 'Support is unavailable. Please retry.');
  }
}

/// Send message to ticket
Future<void> sendTicketMessage({
  required String ticketId,
  required String message,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  try {
    await FirebaseFunctions.instance.httpsCallable('sendSupportMessage').call({
      'schemaVersion': 1,
      'ticketId': ticketId,
      'message': message,
    });
  } on FirebaseFunctionsException catch (error) {
    throw Exception(error.message ?? 'Support reply could not be sent.');
  }
}

Future<void> escalateTicket(String ticketId) async {
  try {
    await FirebaseFunctions.instance
        .httpsCallable('escalateSupportTicket')
        .call({'schemaVersion': 1, 'ticketId': ticketId});
  } on FirebaseFunctionsException catch (error) {
    throw Exception(error.message ?? 'Ticket could not be escalated.');
  }
}

/// Close ticket
Future<void> closeTicket(String ticketId) async {
  await FirebaseFirestore.instance
      .collection('support_tickets')
      .doc(ticketId)
      .update({
        'status': TicketStatus.closed.name,
        'resolvedAt': DateTime.now().toIso8601String(),
      });
}

/// Create dispute
Future<void> createDispute({
  required String tripId,
  required String respondentId,
  required String reason,
  String? description,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  await FirebaseFirestore.instance.collection('disputes').add({
    'tripId': tripId,
    'complainantId': user.uid,
    'respondentId': respondentId,
    'reason': reason,
    'description': description,
    'status': TicketStatus.open.name,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

/// Mark FAQ as helpful
Future<void> markFAQHelpful(String faqId, bool helpful) async {
  final field = helpful ? 'helpfulCount' : 'notHelpfulCount';
  try {
    await FirebaseFirestore.instance.collection('faq').doc(faqId).update({
      field: FieldValue.increment(1),
    });
  } catch (_) {
    // FAQ feedback is optional in the judge build; support tickets stay usable
    // even when no writable FAQ collection is configured.
  }
}
