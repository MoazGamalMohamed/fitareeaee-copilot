import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/booking_model.dart';

// Firestore instance
final _firestore = FirebaseFirestore.instance;

// Create booking
final createBookingProvider = FutureProvider.family<BookingModel, BookingModel>((ref, booking) async {
  final docRef = _firestore.collection('bookings').doc();
  final bookingWithId = BookingModel(
    id: docRef.id,
    tripId: booking.tripId,
    passengerId: booking.passengerId,
    seatsBooked: booking.seatsBooked,
    totalPrice: booking.totalPrice,
    status: 'pending',
    paymentStatus: 'unpaid',
    pickupLocation: booking.pickupLocation,
    dropoffLocation: booking.dropoffLocation,
    pickupTime: booking.pickupTime,
    dropoffTime: booking.dropoffTime,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  await docRef.set(bookingWithId.toJson());
  return bookingWithId;
});

// Get user bookings
final userBookingsProvider = StreamProvider.family<List<BookingModel>, String>((ref, userId) {
  return _firestore
      .collection('bookings')
      .where('passengerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BookingModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Get single booking
final bookingProvider = FutureProvider.family<BookingModel?, String>((ref, bookingId) async {
  final doc = await _firestore.collection('bookings').doc(bookingId).get();
  if (!doc.exists) return null;
  return BookingModel.fromJson({...doc.data()!, 'id': doc.id});
});

// Update booking status
Future<void> updateBookingStatus(String bookingId, String status) async {
  await _firestore.collection('bookings').doc(bookingId).update({
    'status': status,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Cancel booking
Future<void> cancelBooking(String bookingId) async {
  await _firestore.collection('bookings').doc(bookingId).update({
    'status': 'cancelled',
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

