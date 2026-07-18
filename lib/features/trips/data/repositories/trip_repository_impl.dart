import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trip.dart';
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
  Stream<List<Trip>> streamUserTrips(String userId);
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
      await docRef.set(tripWithId.toJson());
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
      await _firestore.collection('trips').doc(trip.id).update(trip.toJson());
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

      final data = _convertTimestamps(doc.data() as Map<String, dynamic>);
      return Trip.fromJson(data);
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
      final trips = <Trip>[];
      for (final doc in snapshot.docs) {
        try {
          final data = _convertTimestamps(doc.data());
          final trip = Trip.fromJson(data);
          trips.add(trip);
        } catch (e) {
          print('Warning: Skipping invalid trip document ${doc.id}: $e');
          continue;
        }
      }
      return trips;
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

      final trips = <Trip>[];
      for (final doc in snapshot.docs) {
        try {
          final data = _convertTimestamps(doc.data());
          final trip = Trip.fromJson(data);
          trips.add(trip);
        } catch (e) {
          print('Warning: Skipping invalid user trip document ${doc.id}: $e');
          continue;
        }
      }
      return trips;
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

      final trips = <Trip>[];
      for (final doc in snapshot.docs) {
        try {
          final data = _convertTimestamps(doc.data());
          final trip = Trip.fromJson(data);
          trips.add(trip);
        } catch (e) {
          print('Warning: Skipping invalid trip document ${doc.id}: $e');
          continue;
        }
      }

      // Filter by date if provided
      if (departureDate != null) {
        final startOfDay = DateTime(departureDate.year, departureDate.month, departureDate.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        trips.removeWhere((trip) =>
            trip.departureTime.isBefore(startOfDay) ||
            trip.departureTime.isAfter(endOfDay));
      }

      return trips;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw AppException(message: 'Failed to search trips: $e');
    }
  }

  @override
  Stream<List<Trip>> streamAvailableTrips({String? excludeUserId}) {
    return _firestore
        .collection('trips')
        .snapshots()
        .map((snapshot) {
      final trips = <Trip>[];
      for (final doc in snapshot.docs) {
        try {
          final data = _convertTimestamps(doc.data());
          final trip = Trip.fromJson(data);
          
          // Exclude user's own trips if excludeUserId is provided
          if (excludeUserId != null && trip.driverId == excludeUserId) {
            continue;
          }
          
          trips.add(trip);
        } catch (e) {
          print('Warning: Skipping invalid trip document ${doc.id}: $e');
          // Skip this document but continue processing others
          continue;
        }
      }
      return trips;
    }).handleError((e) {
      if (e is FirebaseException) {
        throw _handleFirebaseException(e);
      }
      throw AppException(message: 'Failed to stream trips: $e');
    });
  }

  @override
  Stream<List<Trip>> streamUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('driverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final trips = <Trip>[];
      for (final doc in snapshot.docs) {
        try {
          final data = _convertTimestamps(doc.data());
          final trip = Trip.fromJson(data);
          trips.add(trip);
        } catch (e) {
          print('Warning: Skipping invalid user trip document ${doc.id}: $e');
          // Skip this document but continue processing others
          continue;
        }
      }
      return trips;
    }).handleError((e) {
      if (e is FirebaseException) {
        throw _handleFirebaseException(e);
      }
      throw AppException(message: 'Failed to stream user trips: $e');
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

      print('📝 Creating booking document for trip $tripId, passenger $userId');
      
      // Create booking document
      final bookingRef = _firestore.collection('bookings').doc();
      await bookingRef.set({
        'id': bookingRef.id,
        'tripId': tripId,
        'passengerId': userId,
        'driverId': trip.driverId,
        'seatsBooked': 1,
        'totalPrice': trip.pricePerSeat,
        'status': 'confirmed', // Auto-confirm the booking
        'paymentStatus': 'unpaid',
        'pickupLocation': trip.originAddress,
        'dropoffLocation': trip.destinationAddress,
        'pickupTime': trip.departureTime.toIso8601String(),
        'dropoffTime': null,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      print('✅ Booking created: ${bookingRef.id}');

      // Update trip document
      await _firestore.collection('trips').doc(tripId).update({
        'passenger_ids': updatedPassengers,
        'available_seats': updatedAvailable,
        'updated_at': DateTime.now(),
      });
      
      print('✅ Trip updated with passenger');
    } on FirebaseException catch (e) {
      print('❌ Firebase error in bookTrip: $e');
      throw _handleFirebaseException(e);
    } catch (e) {
      print('❌ Error in bookTrip: $e');
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

  /// Convert Firestore Timestamps to ISO strings for JSON parsing
  /// Also ensures all critical fields are present and have safe defaults
  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert timestamp fields to ISO strings
    final timestampFields = ['departure_time', 'created_at', 'updated_at'];
    for (final field in timestampFields) {
      if (converted[field] is Timestamp) {
        converted[field] = (converted[field] as Timestamp).toDate().toIso8601String();
      } else if (converted[field] == null) {
        // Provide default ISO string for missing timestamp fields
        converted[field] = DateTime.now().toIso8601String();
      }
    }

    // Ensure required string fields have defaults if missing
    final requiredFields = {
      'type': 'person',
      'role': 'offer',
      'origin_address': 'Unknown',
      'destination_address': 'Unknown',
      'status': 'pending',
      'driverId': '',
    };

    requiredFields.forEach((field, defaultValue) {
      if (!converted.containsKey(field) || converted[field] == null) {
        converted[field] = defaultValue;
      }
    });

    // Ensure required numeric fields have defaults if missing
    final numericFields = {
      'origin_lat': 0.0,
      'origin_lng': 0.0,
      'destination_lat': 0.0,
      'destination_lng': 0.0,
      'distance': 0.0,
      'estimated_duration': 0,
      'price_per_seat': 0.0,
      'total_seats': 1,
      'available_seats': 0,
    };

    numericFields.forEach((field, defaultValue) {
      if (!converted.containsKey(field) || converted[field] == null) {
        converted[field] = defaultValue;
      }
    });

    // Ensure list fields have empty list defaults
    final listFields = ['passenger_ids', 'amenities', 'package_photo_urls'];
    for (final field in listFields) {
      if (!converted.containsKey(field) || converted[field] == null) {
        converted[field] = [];
      }
    }

    return converted;
  }
}
