import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

enum TransactionType { deposit, withdrawal, payment, refund, payout, fee }
enum TransactionStatus { pending, completed, failed, cancelled }

@freezed
class WalletModel with _$WalletModel {
  const WalletModel._();

  const factory WalletModel({
    required String userId,
    @Default(0.0) double availableBalance,
    @Default(0.0) double pendingBalance,
    @Default(0.0) double totalEarnings,
    @Default(0.0) double totalSpent,
    @Default('USD') String currency,
    String? defaultPayoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? bankRoutingNumber,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  /// Total balance (available + pending)
  double get totalBalance => availableBalance + pendingBalance;

  /// Check if can withdraw amount
  bool canWithdraw(double amount) => availableBalance >= amount;

  /// Check if has payout method
  bool get hasPayoutMethod => 
      bankAccountNumber != null && 
      bankName != null && 
      bankAccountNumber!.isNotEmpty;
}

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    required String userId,
    required TransactionType type,
    required TransactionStatus status,
    required double amount,
    required String currency,
    required String description,
    String? tripId,
    String? bookingId,
    String? paymentIntentId,
    String? counterpartyId,
    String? counterpartyName,
    String? failureReason,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}

@freezed
class PayoutRequest with _$PayoutRequest {
  const factory PayoutRequest({
    required String id,
    required String userId,
    required double amount,
    required String currency,
    required TransactionStatus status,
    required String payoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? failureReason,
    required DateTime createdAt,
    DateTime? processedAt,
    String? processedBy,
  }) = _PayoutRequest;

  factory PayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestFromJson(json);
}

