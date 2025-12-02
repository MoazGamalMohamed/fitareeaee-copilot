import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trip.dart';
import '../models/trip_model.dart';
import '../../../../core/utils/exceptions/app_exceptions.dart';

abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(String tripId);
  Future<Trip> getTripById(String tripId);
  Future<List<Trip>> getAllTrips();
  Future<List<Trip>> getUserTrips(String userId);
  Future<List<Trip>> searchTrips({
    required String origin,
    required String destination,
    DateTime? departureDate,
    String? tripType,
  });
  Stream<List<Trip>> streamAvailableTrips();
  Future<void> bookTrip(String tripId, String userId);
  Future<void> cancelBooking(String tripId, String userId);
}

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore;

  const TripRepositoryImpl({
    required FirebaseFirestore firestore,
  })  : _firestore = firestore;

  @override
  Future<Trip> createTrip(Trip trip) async {
    try {
      // Use auto-generated ID if trip.id is empty
      final DocumentReference docRef;
      if (trip.id.isEmpty) {
        docRef = _firestore.collection('trips').doc();
      } else {
        docRef = _firestore.collection('trips').doc(trip.id);
      }

      // Create trip with the generated ID
      final tripWithId = trip.copyWith(id: docRef.id);
      final model = tripWithId.toModel();
      await docRef.set(model.toFirestore());
      return tripWithId;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to create trip: $e');
    }
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    try {
      final model = trip.toModel();
      await _firestore.collection('trips').doc(trip.id).update(
            model.toFirestore(),
          );
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to update trip: $e');
    }
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    try {
      await _firestore.collection('trips').doc(tripId).delete();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to delete trip: $e');
    }
  }

  @override
  Future<Trip> getTripById(String tripId) async {
    try {
      final doc = await _firestore.collection('trips').doc(tripId).get();

      if (!doc.exists) {
        throw AppException(message: 'Trip not found');
      }

      final model = TripModel.fromJson(doc.data() as Map<String, dynamic>);
      return model.toEntity();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to get trip: $e');
    }
  }

  @override
  Future<List<Trip>> getAllTrips() async {
    try {
      final snapshot = await _firestore.collection('trips').get();
      return snapshot.docs
          .map((doc) =>
              TripModel.fromJson(doc.data())
                  .toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to get trips: $e');
    }
  }

  @override
  Future<List<Trip>> getUserTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('driverId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) =>
              TripModel.fromJson(doc.data())
                  .toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to get user trips: $e');
    }
  }

  @override
  Future<List<Trip>> searchTrips({
    required String origin,
    required String destination,
    DateTime? departureDate,
    String? tripType,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('trips');

      if (origin.isNotEmpty) {
        query = query.where('origin_address',
            isGreaterThanOrEqualTo: origin.toLowerCase());
      }

      if (destination.isNotEmpty) {
        query = query.where('destination_address',
            isGreaterThanOrEqualTo: destination.toLowerCase());
      }

      if (tripType != null) {
        query = query.where('type', isEqualTo: tripType);
      }

      final snapshot = await query.get();

      var trips = snapshot.docs
          .map((doc) =>
              TripModel.fromJson(doc.data())
                  .toEntity())
          .toList();

      // Filter by date if provided
      if (departureDate != null) {
        final startOfDay = DateTime(departureDate.year, departureDate.month, departureDate.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        trips = trips
            .where((trip) =>
                trip.departureTime.isAfter(startOfDay) &&
                trip.departureTime.isBefore(endOfDay))
            .toList();
      }

      return trips;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to search trips: $e');
    }
  }

  @override
  Stream<List<Trip>> streamAvailableTrips() {
    return _firestore
        .collection('trips')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              TripModel.fromJson(doc.data())
                  .toEntity())
          .toList();
    }).handleError((e) {
      if (e is FirebaseException) {
        throw _handleFirebaseException(e);
      }
      throw AppException(message: 'Failed to stream trips: $e');
    });
  }

  @override
  Future<void> bookTrip(String tripId, String userId) async {
    try {
      final trip = await getTripById(tripId);

      if (trip.isFull) {
        throw AppException(message: 'No available seats');
      }

      if (trip.hasPassenger(userId)) {
        throw AppException(message: 'Already booked this trip');
      }

      final updatedPassengers = [...trip.passengerIds, userId];
      final updatedAvailable = trip.availableSeats - 1;

      await _firestore.collection('trips').doc(tripId).update({
        'passenger_ids': updatedPassengers,
        'available_seats': updatedAvailable,
        'updated_at': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to book trip: $e');
    }
  }

  @override
  Future<void> cancelBooking(String tripId, String userId) async {
    try {
      final trip = await getTripById(tripId);

      if (!trip.hasPassenger(userId)) {
        throw AppException(message: 'Not booked on this trip');
      }

      final updatedPassengers =
          trip.passengerIds.where((id) => id != userId).toList();
      final updatedAvailable = trip.availableSeats + 1;

      await _firestore.collection('trips').doc(tripId).update({
        'passenger_ids': updatedPassengers,
        'available_seats': updatedAvailable,
        'updated_at': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to cancel booking: $e');
    }
  }

  AppException _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AppException(message: 'Permission denied');
      case 'not-found':
        return AppException(message: 'Trip not found');
      case 'unavailable':
        return NetworkException('Service temporarily unavailable');
      default:
        return AppException(message: 'Firebase error: ${e.message}');
    }
  }
}
