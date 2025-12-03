import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/support_model.dart';

/// Provider for user's support tickets
final userTicketsProvider = StreamProvider<List<SupportTicket>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  // Simplified query without orderBy to avoid needing composite index
  return FirebaseFirestore.instance
      .collection('support_tickets')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        final tickets = snapshot.docs
            .map((doc) => SupportTicket.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
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
final ticketMessagesProvider = StreamProvider.family<List<TicketMessage>, String>((ref, ticketId) {
  return FirebaseFirestore.instance
      .collection('support_tickets')
      .doc(ticketId)
      .collection('messages')
      .orderBy('createdAt')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => TicketMessage.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

/// Default FAQ items when Firestore collection is empty
List<FAQItem> _getDefaultFAQs() {
  return [
    FAQItem(
      id: 'faq_1',
      question: 'How do I book a ride?',
      answer: 'Browse available trips, select one that matches your route, and tap "Book" to request a seat. The driver will confirm your booking.',
      category: 'Booking',
    ),
    FAQItem(
      id: 'faq_2',
      question: 'How do payments work?',
      answer: 'Payments are held in escrow until the trip is completed. Once the driver confirms arrival, funds are released to them.',
      category: 'Payments',
    ),
    FAQItem(
      id: 'faq_3',
      question: 'How do I become a driver?',
      answer: 'Go to your profile, tap "Become a Driver", and complete the verification process including uploading your ID and vehicle information.',
      category: 'Drivers',
    ),
    FAQItem(
      id: 'faq_4',
      question: 'What if I need to cancel?',
      answer: 'You can cancel a booking from your trips page. Cancellation policies vary - check the trip details for specific terms.',
      category: 'Booking',
    ),
    FAQItem(
      id: 'faq_5',
      question: 'How do I contact support?',
      answer: 'Submit a support ticket from this Help Center. Our team typically responds within 24 hours.',
      category: 'Support',
    ),
  ];
}

/// Provider for FAQ items
final faqProvider = FutureProvider<List<FAQItem>>((ref) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('faq')
        .get();

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

  final ticketRef = await FirebaseFirestore.instance.collection('support_tickets').add({
    'userId': user.uid,
    'tripId': tripId,
    'category': category.name,
    'status': TicketStatus.open.name,
    'subject': subject,
    'description': description,
    'createdAt': DateTime.now().toIso8601String(),
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
  await FirebaseFirestore.instance
      .collection('faq')
      .doc(faqId)
      .update({field: FieldValue.increment(1)});
}

