import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment status enum
enum PaymentStatus {
  pending,      // Payment initiated
  processing,   // Payment being processed
  escrow,       // Payment held in escrow
  completed,    // Payment released to payee
  failed,       // Payment failed
  refunded,     // Payment refunded to payer
  disputed,     // Payment under dispute
}

/// Escrow status enum
enum EscrowStatus {
  none,         // No escrow
  held,         // Funds held in escrow
  releasing,    // Funds being released
  released,     // Funds released to payee
  refunding,    // Funds being refunded
  refunded,     // Funds refunded to payer
}

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String bookingId,
    required String payerId,
    required String payeeId,
    required double amount,
    required String currency,
    required String paymentMethod, // 'card', 'wallet', 'bank_transfer', 'stripe'
    required String status, // PaymentStatus values
    String? transactionId,
    String? stripePaymentIntentId,
    String? stripeTransferId,
    required DateTime createdAt,
    DateTime? completedAt,
    // Escrow fields
    @Default('none') String escrowStatus, // EscrowStatus values
    DateTime? escrowHeldAt,
    DateTime? escrowReleasedAt,
    // Fee breakdown
    @Default(0.0) double platformFee,
    @Default(0.0) double processingFee,
    @Default(0.0) double netAmount, // Amount after fees
    // Refund info
    String? refundReason,
    DateTime? refundedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}
