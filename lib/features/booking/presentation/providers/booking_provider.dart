import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/booking_model.dart';

final _firestore = FirebaseFirestore.instance;

BookingModel _bookingFromFirestore(
  DocumentSnapshot<Map<String, dynamic>> document,
) {
  final data = Map<String, dynamic>.from(document.data()!);
  for (final field in ['pickupTime', 'dropoffTime', 'createdAt', 'updatedAt']) {
    final value = data[field];
    if (value is Timestamp) {
      data[field] = value.toDate().toIso8601String();
    } else if (value is DateTime) {
      data[field] = value.toIso8601String();
    }
  }
  return BookingModel.fromJson({...data, 'id': document.id});
}

/// Read-only booking stream. Creation and cancellation are intentionally
/// performed only by the authenticated transactional Cloud Functions.
final userBookingsProvider = StreamProvider.family<List<BookingModel>, String>((
  ref,
  userId,
) {
  return _firestore
      .collection('bookings')
      .where('passengerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(_bookingFromFirestore).toList());
});

final bookingProvider = FutureProvider.family<BookingModel?, String>((
  ref,
  bookingId,
) async {
  final doc = await _firestore.collection('bookings').doc(bookingId).get();
  if (!doc.exists) return null;
  return _bookingFromFirestore(doc);
});
