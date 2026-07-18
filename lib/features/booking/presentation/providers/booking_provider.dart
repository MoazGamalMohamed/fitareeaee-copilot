import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/booking_model.dart';

// Firestore instance
final _firestore = FirebaseFirestore.instance;

// Create booking
final createBookingProvider = FutureProvider.family<BookingModel, BookingModel>((
  ref,
  booking,
) async {
  print(
    '🎬 START: Creating booking for passenger=${booking.passengerId}, driver=${booking.driverId}, trip=${booking.tripId}',
  );

  try {
    final docRef = _firestore.collection('bookings').doc();
    print('📝 Generated booking ID: ${docRef.id}');

    final bookingWithId = BookingModel(
      id: docRef.id,
      tripId: booking.tripId,
      passengerId: booking.passengerId,
      driverId: booking.driverId, // Include driver ID
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

    print('💾 Saving booking to Firestore: ${bookingWithId.toJson()}');

    await docRef.set(bookingWithId.toJson());

    print('✅ SUCCESS: Booking saved to Firestore with ID: ${docRef.id}');
    print('🔄 Firestore should trigger StreamProvider update now...');

    return bookingWithId;
  } catch (e, stackTrace) {
    print('❌ CRITICAL ERROR creating booking: $e');
    print('📚 Stack trace: $stackTrace');
    print(
      '⚠️ Booking data: passengerId=${booking.passengerId}, driverId=${booking.driverId}',
    );
    rethrow;
  }
});

// Get user bookings
// COMPOSITE INDEX REQUIRED:
// Collection: bookings
// Fields: passengerId (ASCENDING), createdAt (DESCENDING)
// Deploy with: firebase deploy --only firestore:indexes
// Or create via Firebase Console using the URL from the error message
final userBookingsProvider = StreamProvider.family<List<BookingModel>, String>((
  ref,
  userId,
) {
  print('🔍 Querying bookings for userId: $userId');
  return _firestore
      .collection('bookings')
      .where('passengerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .handleError((error) {
        print('❌ Error querying bookings: $error');
        // If index is missing, log helpful error message
        if (error.toString().contains('failed-precondition') ||
            error.toString().contains('requires an index')) {
          print('❌ FIRESTORE INDEX REQUIRED for bookings query!');
          print('📋 Collection: bookings');
          print('📋 Fields: passengerId (ASC), createdAt (DESC)');
          print('🔧 Run: firebase deploy --only firestore:indexes');
          print('🔗 Or click the index creation URL in the error above');
        }
        throw error;
      })
      .map((snapshot) {
        print('📦 Retrieved ${snapshot.docs.length} bookings from Firestore');
        final bookings = snapshot.docs.map((doc) {
          final data = doc.data();
          print(
            '  - Booking ${doc.id}: status=${data['status']}, paymentStatus=${data['paymentStatus']}',
          );
          return BookingModel.fromJson({...data, 'id': doc.id});
        }).toList();
        return bookings;
      });
});

// Get single booking
final bookingProvider = FutureProvider.family<BookingModel?, String>((
  ref,
  bookingId,
) async {
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
