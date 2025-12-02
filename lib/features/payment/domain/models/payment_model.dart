import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String bookingId,
    required String payerId,
    required String payeeId,
    required double amount,
    required String currency,
    required String paymentMethod, // 'card', 'wallet', 'bank_transfer'
    required String status, // 'pending', 'processing', 'completed', 'failed', 'refunded'
    required String? transactionId,
    required DateTime createdAt,
    required DateTime? completedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}
