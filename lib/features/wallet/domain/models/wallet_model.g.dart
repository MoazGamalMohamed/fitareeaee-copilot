// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletModelImpl _$$WalletModelImplFromJson(Map<String, dynamic> json) =>
    _$WalletModelImpl(
      userId: json['userId'] as String,
      availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      defaultPayoutMethod: json['defaultPayoutMethod'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankName: json['bankName'] as String?,
      bankRoutingNumber: json['bankRoutingNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WalletModelImplToJson(_$WalletModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'availableBalance': instance.availableBalance,
      'pendingBalance': instance.pendingBalance,
      'totalEarnings': instance.totalEarnings,
      'totalSpent': instance.totalSpent,
      'currency': instance.currency,
      'defaultPayoutMethod': instance.defaultPayoutMethod,
      'bankAccountNumber': instance.bankAccountNumber,
      'bankName': instance.bankName,
      'bankRoutingNumber': instance.bankRoutingNumber,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$WalletTransactionImpl _$$WalletTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$WalletTransactionImpl(
  id: json['id'] as String,
  oderId: json['oderId'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  description: json['description'] as String,
  tripId: json['tripId'] as String?,
  bookingId: json['bookingId'] as String?,
  paymentIntentId: json['paymentIntentId'] as String?,
  counterpartyId: json['counterpartyId'] as String?,
  counterpartyName: json['counterpartyName'] as String?,
  failureReason: json['failureReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$WalletTransactionImplToJson(
  _$WalletTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'oderId': instance.oderId,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'status': _$TransactionStatusEnumMap[instance.status]!,
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
  'tripId': instance.tripId,
  'bookingId': instance.bookingId,
  'paymentIntentId': instance.paymentIntentId,
  'counterpartyId': instance.counterpartyId,
  'counterpartyName': instance.counterpartyName,
  'failureReason': instance.failureReason,
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

const _$TransactionTypeEnumMap = {
  TransactionType.deposit: 'deposit',
  TransactionType.withdrawal: 'withdrawal',
  TransactionType.payment: 'payment',
  TransactionType.refund: 'refund',
  TransactionType.payout: 'payout',
  TransactionType.fee: 'fee',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
};

_$PayoutRequestImpl _$$PayoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$PayoutRequestImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      payoutMethod: json['payoutMethod'] as String,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankName: json['bankName'] as String?,
      failureReason: json['failureReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      processedBy: json['processedBy'] as String?,
    );

Map<String, dynamic> _$$PayoutRequestImplToJson(_$PayoutRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'payoutMethod': instance.payoutMethod,
      'bankAccountNumber': instance.bankAccountNumber,
      'bankName': instance.bankName,
      'failureReason': instance.failureReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'processedBy': instance.processedBy,
    };
