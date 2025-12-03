import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// Trip types
enum TripType { person, package }

/// Trip directions
enum TripDirection { offer, request }

/// Trip status
enum TripStatus { pending, accepted, inProgress, completed, cancelled }

/// Trip entity - supports combined person + package trips
@freezed
class Trip with _$Trip {
  const Trip._();
  
  const factory Trip({
    required String id,
    @JsonKey(name: 'type') required String type, // 'person', 'package', or 'both'
    @JsonKey(name: 'role') required String role, // 'offer' or 'request'
    required String driverId,
    String? passengerId,
    @JsonKey(name: 'origin_address') required String originAddress,
    @JsonKey(name: 'destination_address') required String destinationAddress,
    @JsonKey(name: 'origin_lat') required double originLat,
    @JsonKey(name: 'origin_lng') required double originLng,
    @JsonKey(name: 'destination_lat') required double destinationLat,
    @JsonKey(name: 'destination_lng') required double destinationLng,
    @JsonKey(name: 'departure_time') required DateTime departureTime,
    required double distance, // km
    @JsonKey(name: 'estimated_duration') required int estimatedDuration, // minutes
    @JsonKey(name: 'price_per_seat') required double pricePerSeat,
    @JsonKey(name: 'total_seats') required int totalSeats,
    @JsonKey(name: 'available_seats') required int availableSeats,
    @JsonKey(name: 'passenger_ids') @Default([]) List<String> passengerIds,
    @Default('pending') String status,
    String? description,
    @Default(false) bool allowPets,
    @Default(false) bool allowSmoking,
    @Default([]) List<String> amenities,
    @Default({}) Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    // Combined trip support
    @JsonKey(name: 'includes_person') @Default(true) bool includesPerson,
    @JsonKey(name: 'includes_package') @Default(false) bool includesPackage,

    // Package-specific fields
    @JsonKey(name: 'package_weight') double? packageWeight, // kg
    @JsonKey(name: 'package_description') String? packageDescription,
    @JsonKey(name: 'package_photo_urls') @Default([]) List<String> packagePhotoUrls,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  /// Computed properties
  bool get isAvailable => status == 'pending' && availableSeats > 0;
  bool get isPerson => type == 'person';
  bool get isPackage => type == 'package';
  bool get isOffer => role == 'offer';
  bool get isRequest => role == 'request';
  bool get isFull => availableSeats <= 0;
  bool get isPast => departureTime.isBefore(DateTime.now());
  
  String get typeDisplay => isPerson ? 'Person Transport' : 'Package Delivery';
  String get directionDisplay => isOffer ? 'Offering' : 'Requesting';
  String get statusDisplay => status.replaceFirst(status[0], status[0].toUpperCase());
  String get priceDisplay => '\$${pricePerSeat.toStringAsFixed(2)}/seat';
  String get distanceDisplay => '${distance.toStringAsFixed(1)} km';
  String get durationDisplay => '${(estimatedDuration / 60).toStringAsFixed(0)}h ${estimatedDuration % 60}m';
  
  Duration get timeUntilDeparture => departureTime.difference(DateTime.now());
  bool get isDepartingSoon => timeUntilDeparture.inMinutes <= 60 && timeUntilDeparture.inMinutes > 0;
  
  bool isCreatedBy(String userId) => driverId == userId;
  bool hasPassenger(String userId) => passengerIds.contains(userId);
  
  String get timeDisplay {
    if (isPast) return 'Departed';
    final duration = timeUntilDeparture;
    if (duration.inDays > 0) return 'In ${duration.inDays}d';
    if (duration.inHours > 0) return 'In ${duration.inHours}h';
    return 'In ${duration.inMinutes}m';
  }
}
