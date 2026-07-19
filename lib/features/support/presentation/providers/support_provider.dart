import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          'Browse available trips, select one that matches your route, and tap "Book" to request a seat. The driver will confirm your booking.',
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
          'Submit a support ticket from this Help Center. The app adds instant guidance first, then keeps the ticket open for admin or support follow-up.',
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

  final ticketRef = await FirebaseFirestore.instance
      .collection('support_tickets')
      .add({
        'userId': user.uid,
        'tripId': tripId,
        'category': category.name,
        'status': TicketStatus.open.name,
        'subject': subject,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

  // Add initial message
  await ticketRef.collection('messages').add({
    'ticketId': ticketRef.id,
    'senderId': user.uid,
    'senderName': user.displayName ?? 'User',
    'isStaff': false,
    'message': description,
    'createdAt': DateTime.now().toIso8601String(),
  });

  await ticketRef.collection('messages').add({
    'ticketId': ticketRef.id,
    'senderId': user.uid,
    'senderName': 'Fitareeaee Support Copilot guidance',
    'isStaff': false,
    'message': _instantSupportGuidance(category),
    'createdAt': DateTime.now().toIso8601String(),
  });

  return SupportTicket(
    id: ticketRef.id,
    userId: user.uid,
    tripId: tripId,
    category: category,
    status: TicketStatus.open,
    subject: subject,
    description: description,
    createdAt: DateTime.now(),
  );
}

/// Send message to ticket
Future<void> sendTicketMessage({
  required String ticketId,
  required String message,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated');

  await FirebaseFirestore.instance
      .collection('support_tickets')
      .doc(ticketId)
      .collection('messages')
      .add({
        'ticketId': ticketId,
        'senderId': user.uid,
        'senderName': user.displayName ?? 'User',
        'isStaff': false,
        'message': message,
        'createdAt': DateTime.now().toIso8601String(),
      });

  // Update ticket timestamp
  await FirebaseFirestore.instance
      .collection('support_tickets')
      .doc(ticketId)
      .update({'updatedAt': DateTime.now().toIso8601String()});
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

String _instantSupportGuidance(TicketCategory category) {
  switch (category) {
    case TicketCategory.payment:
      return 'Thanks for opening a payment issue. In this judge build no real money is moved. A support/admin reviewer should verify the trip, booking status, and any documented payment concern before action is taken.';
    case TicketCategory.trip:
      return 'Thanks for opening a trip issue. Please include the route, scheduled time, and what changed. Confirmed-trip chat is only active while the booking is active; cancelled or completed trips should stay in support.';
    case TicketCategory.account:
      return 'Thanks for opening an account issue. Do not send passwords, full IDs, or private document numbers here. An admin can review account status and verification history.';
    case TicketCategory.safety:
      return 'Thanks for opening a safety issue. Fitareeaee is not an emergency service. If anyone may be in immediate danger, contact local emergency services first, then keep this ticket for admin follow-up.';
    case TicketCategory.technical:
      return 'Thanks for reporting a technical issue. Please include the screen name, the action you tapped, and the exact error text if visible.';
    case TicketCategory.other:
      return 'Thanks for contacting support. If this answer does not solve it, keep this ticket open and an admin/support reviewer can follow up.';
  }
}
