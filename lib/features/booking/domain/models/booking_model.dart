import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String tripId,
    required String passengerId,
    required int seatsBooked,
    required double totalPrice,
    required String status, // 'pending', 'confirmed', 'completed', 'cancelled'
    required String paymentStatus, // 'unpaid', 'paid', 'refunded'
    required String? pickupLocation,
    required String? dropoffLocation,
    required DateTime? pickupTime,
    required DateTime? dropoffTime,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
}
