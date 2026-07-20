import 'dart:async';

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
final userBookingsProvider = StreamProvider.autoDispose
    .family<List<BookingModel>, String>((ref, userId) {
      return _firestore
          .collection('bookings')
          .where('passengerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(_bookingFromFirestore).toList());
    });

/// All bookings where the user is either the passenger or the trip owner.
/// Two rule-compatible equality queries are merged locally.
final participantBookingsProvider = StreamProvider.autoDispose
    .family<List<BookingModel>, String>((ref, userId) {
      final controller = StreamController<List<BookingModel>>();
      var passengerBookings = <BookingModel>[];
      var driverBookings = <BookingModel>[];

      void publish() {
        final byId = <String, BookingModel>{
          for (final booking in passengerBookings) booking.id: booking,
          for (final booking in driverBookings) booking.id: booking,
        };
        final merged = byId.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (!controller.isClosed) controller.add(merged);
      }

      void report(Object error, StackTrace stackTrace) {
        if (!controller.isClosed) controller.addError(error, stackTrace);
      }

      final passengerSubscription = _firestore
          .collection('bookings')
          .where('passengerId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            passengerBookings = snapshot.docs
                .map(_bookingFromFirestore)
                .toList();
            publish();
          }, onError: report);
      final driverSubscription = _firestore
          .collection('bookings')
          .where('driverId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            driverBookings = snapshot.docs.map(_bookingFromFirestore).toList();
            publish();
          }, onError: report);

      ref.onDispose(() async {
        await passengerSubscription.cancel();
        await driverSubscription.cancel();
        await controller.close();
      });
      return controller.stream;
    });

final bookingProvider = FutureProvider.autoDispose
    .family<BookingModel?, String>((ref, bookingId) async {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (!doc.exists) return null;
      return _bookingFromFirestore(doc);
    });
