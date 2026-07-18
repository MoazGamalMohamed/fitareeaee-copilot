import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../../domain/models/tracking_model.dart';
import '../../../../core/utils/firestore_helpers.dart';

final locationServiceProvider = Provider((ref) => Location());

/// Provider for trip tracking data
final tripTrackingProvider = StreamProvider.family<TripTracking?, String>((
  ref,
  tripId,
) {
  return FirebaseFirestore.instance
      .collection('trip_tracking')
      .doc(tripId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;
        final data = FirestoreHelpers.convertTimestamps({
          ...doc.data()!,
          'tripId': tripId,
        });
        return TripTracking.fromJson(data);
      });
});

/// Provider for live location updates
final liveLocationProvider = StreamProvider.family<LiveLocation?, String>((
  ref,
  tripId,
) {
  return FirebaseFirestore.instance
      .collection('live_locations')
      .doc(tripId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;
        final data = FirestoreHelpers.convertTimestamps({
          ...doc.data()!,
          'tripId': tripId,
        });
        return LiveLocation.fromJson(data);
      });
});

/// Start tracking for a trip
Future<void> startTracking({
  required String tripId,
  required String driverId,
  required List<String> sharedWithUserIds,
  double? originLat,
  double? originLng,
  double? destLat,
  double? destLng,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  await firestore.collection('trip_tracking').doc(tripId).set({
    'tripId': tripId,
    'driverId': driverId,
    'status': TrackingStatus.active.name,
    'sharedWithUserIds': sharedWithUserIds,
    'originLatitude': originLat,
    'originLongitude': originLng,
    'destinationLatitude': destLat,
    'destinationLongitude': destLng,
    'startedAt': now.toIso8601String(),
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  });
}

/// Update live location
Future<void> updateLiveLocation({
  required String tripId,
  required String userId,
  required double latitude,
  required double longitude,
  double? speed,
  double? heading,
  double? accuracy,
}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  // Update live location document
  await firestore.collection('live_locations').doc(tripId).set({
    'userId': userId,
    'tripId': tripId,
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'heading': heading,
    'accuracy': accuracy,
    'timestamp': now.toIso8601String(),
  });

  // Also add to location history
  await firestore.collection('location_history').add({
    'tripId': tripId,
    'userId': userId,
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'heading': heading,
    'timestamp': now.toIso8601String(),
  });

  // Update trip tracking status
  await firestore.collection('trip_tracking').doc(tripId).update({
    'updatedAt': now.toIso8601String(),
  });
}

/// Stop tracking
Future<void> stopTracking(String tripId) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();

  await firestore.collection('trip_tracking').doc(tripId).update({
    'status': TrackingStatus.completed.name,
    'completedAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  });

  // Remove live location
  await firestore.collection('live_locations').doc(tripId).delete();
}

/// Location tracking service
class LocationTrackingService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  String? _currentTripId;
  String? _currentUserId;

  Future<bool> requestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) return false;
    }
    return true;
  }

  Future<void> startLocationUpdates({
    required String tripId,
    required String userId,
  }) async {
    _currentTripId = tripId;
    _currentUserId = userId;

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000, // Update every 5 seconds
      distanceFilter: 10, // Minimum 10 meters movement
    );

    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (_currentTripId != null && _currentUserId != null) {
        updateLiveLocation(
          tripId: _currentTripId!,
          userId: _currentUserId!,
          latitude: locationData.latitude ?? 0,
          longitude: locationData.longitude ?? 0,
          speed: locationData.speed,
          heading: locationData.heading,
          accuracy: locationData.accuracy,
        );
      }
    });
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _currentTripId = null;
    _currentUserId = null;
  }
}
