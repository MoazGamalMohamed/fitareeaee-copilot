import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_model.freezed.dart';
part 'tracking_model.g.dart';

enum TrackingStatus { inactive, active, paused, completed }

@freezed
class LiveLocation with _$LiveLocation {
  const factory LiveLocation({
    required String oderId,
    required String tripId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
    double? accuracy,
    required DateTime timestamp,
  }) = _LiveLocation;

  factory LiveLocation.fromJson(Map<String, dynamic> json) =>
      _$LiveLocationFromJson(json);
}

@freezed
class TripTracking with _$TripTracking {
  const TripTracking._();

  const factory TripTracking({
    required String tripId,
    required String driverId,
    required TrackingStatus status,
    LiveLocation? currentLocation,
    @Default([]) List<String> sharedWithUserIds,
    double? originLatitude,
    double? originLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    double? estimatedDistanceKm,
    int? estimatedDurationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TripTracking;

  factory TripTracking.fromJson(Map<String, dynamic> json) =>
      _$TripTrackingFromJson(json);

  /// Check if tracking is active
  bool get isActive => status == TrackingStatus.active;

  /// Check if user can view this tracking
  bool canViewTracking(String userId) =>
      userId == driverId || sharedWithUserIds.contains(userId);
}

@freezed
class LocationHistory with _$LocationHistory {
  const factory LocationHistory({
    required String id,
    required String tripId,
    required String userId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
    required DateTime timestamp,
  }) = _LocationHistory;

  factory LocationHistory.fromJson(Map<String, dynamic> json) =>
      _$LocationHistoryFromJson(json);
}

