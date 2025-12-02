import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required String id,
    required String driverId,
    required String startLocation,
    required String endLocation,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    required DateTime departureTime,
    required double distance, // in km
    required double estimatedDuration, // in minutes
    required double pricePerSeat,
    required int totalSeats,
    required int availableSeats,
    required List<String> passengerIds,
    required String status, // 'pending', 'in_progress', 'completed', 'cancelled'
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);
}
