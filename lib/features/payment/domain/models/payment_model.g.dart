// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      payerId: json['payerId'] as String,
      payeeId: json['payeeId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      stripeTransferId: json['stripeTransferId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      escrowStatus: json['escrowStatus'] as String? ?? 'none',
      escrowHeldAt: json['escrowHeldAt'] == null
          ? null
          : DateTime.parse(json['escrowHeldAt'] as String),
      escrowReleasedAt: json['escrowReleasedAt'] == null
          ? null
          : DateTime.parse(json['escrowReleasedAt'] as String),
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      processingFee: (json['processingFee'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      refundReason: json['refundReason'] as String?,
      refundedAt: json['refundedAt'] == null
          ? null
          : DateTime.parse(json['refundedAt'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'payerId': instance.payerId,
      'payeeId': instance.payeeId,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'transactionId': instance.transactionId,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'stripeTransferId': instance.stripeTransferId,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'escrowStatus': instance.escrowStatus,
      'escrowHeldAt': instance.escrowHeldAt?.toIso8601String(),
      'escrowReleasedAt': instance.escrowReleasedAt?.toIso8601String(),
      'platformFee': instance.platformFee,
      'processingFee': instance.processingFee,
      'netAmount': instance.netAmount,
      'refundReason': instance.refundReason,
      'refundedAt': instance.refundedAt?.toIso8601String(),
    };
