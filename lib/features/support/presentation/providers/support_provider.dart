import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/support_model.dart';

/// Provider for user's support tickets
final userTicketsProvider = StreamProvider<List<SupportTicket>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('support_tickets')
      .where('userId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SupportTicket.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
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

/// Provider for FAQ items
final faqProvider = FutureProvider<List<FAQItem>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('faq')
      .orderBy('category')
      .get();

  return snapshot.docs
      .map((doc) => FAQItem.fromJson({...doc.data(), 'id': doc.id}))
      .toList();
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

