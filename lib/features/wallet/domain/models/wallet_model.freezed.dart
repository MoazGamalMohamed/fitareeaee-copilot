// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) {
  return _WalletModel.fromJson(json);
}

/// @nodoc
mixin _$WalletModel {
  String get userId => throw _privateConstructorUsedError;
  double get availableBalance => throw _privateConstructorUsedError;
  double get pendingBalance => throw _privateConstructorUsedError;
  double get totalEarnings => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get defaultPayoutMethod => throw _privateConstructorUsedError;
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankRoutingNumber => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WalletModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletModelCopyWith<WalletModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletModelCopyWith<$Res> {
  factory $WalletModelCopyWith(
    WalletModel value,
    $Res Function(WalletModel) then,
  ) = _$WalletModelCopyWithImpl<$Res, WalletModel>;
  @useResult
  $Res call({
    String userId,
    double availableBalance,
    double pendingBalance,
    double totalEarnings,
    double totalSpent,
    String currency,
    String? defaultPayoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? bankRoutingNumber,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$WalletModelCopyWithImpl<$Res, $Val extends WalletModel>
    implements $WalletModelCopyWith<$Res> {
  _$WalletModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? totalEarnings = null,
    Object? totalSpent = null,
    Object? currency = null,
    Object? defaultPayoutMethod = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankName = freezed,
    Object? bankRoutingNumber = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            availableBalance: null == availableBalance
                ? _value.availableBalance
                : availableBalance // ignore: cast_nullable_to_non_nullable
                      as double,
            pendingBalance: null == pendingBalance
                ? _value.pendingBalance
                : pendingBalance // ignore: cast_nullable_to_non_nullable
                      as double,
            totalEarnings: null == totalEarnings
                ? _value.totalEarnings
                : totalEarnings // ignore: cast_nullable_to_non_nullable
                      as double,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultPayoutMethod: freezed == defaultPayoutMethod
                ? _value.defaultPayoutMethod
                : defaultPayoutMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankAccountNumber: freezed == bankAccountNumber
                ? _value.bankAccountNumber
                : bankAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankName: freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankRoutingNumber: freezed == bankRoutingNumber
                ? _value.bankRoutingNumber
                : bankRoutingNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalletModelImplCopyWith<$Res>
    implements $WalletModelCopyWith<$Res> {
  factory _$$WalletModelImplCopyWith(
    _$WalletModelImpl value,
    $Res Function(_$WalletModelImpl) then,
  ) = __$$WalletModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    double availableBalance,
    double pendingBalance,
    double totalEarnings,
    double totalSpent,
    String currency,
    String? defaultPayoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? bankRoutingNumber,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$WalletModelImplCopyWithImpl<$Res>
    extends _$WalletModelCopyWithImpl<$Res, _$WalletModelImpl>
    implements _$$WalletModelImplCopyWith<$Res> {
  __$$WalletModelImplCopyWithImpl(
    _$WalletModelImpl _value,
    $Res Function(_$WalletModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? totalEarnings = null,
    Object? totalSpent = null,
    Object? currency = null,
    Object? defaultPayoutMethod = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankName = freezed,
    Object? bankRoutingNumber = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WalletModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        availableBalance: null == availableBalance
            ? _value.availableBalance
            : availableBalance // ignore: cast_nullable_to_non_nullable
                  as double,
        pendingBalance: null == pendingBalance
            ? _value.pendingBalance
            : pendingBalance // ignore: cast_nullable_to_non_nullable
                  as double,
        totalEarnings: null == totalEarnings
            ? _value.totalEarnings
            : totalEarnings // ignore: cast_nullable_to_non_nullable
                  as double,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultPayoutMethod: freezed == defaultPayoutMethod
            ? _value.defaultPayoutMethod
            : defaultPayoutMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankAccountNumber: freezed == bankAccountNumber
            ? _value.bankAccountNumber
            : bankAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankName: freezed == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankRoutingNumber: freezed == bankRoutingNumber
            ? _value.bankRoutingNumber
            : bankRoutingNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletModelImpl extends _WalletModel {
  const _$WalletModelImpl({
    required this.userId,
    this.availableBalance = 0.0,
    this.pendingBalance = 0.0,
    this.totalEarnings = 0.0,
    this.totalSpent = 0.0,
    this.currency = 'USD',
    this.defaultPayoutMethod,
    this.bankAccountNumber,
    this.bankName,
    this.bankRoutingNumber,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$WalletModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletModelImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final double availableBalance;
  @override
  @JsonKey()
  final double pendingBalance;
  @override
  @JsonKey()
  final double totalEarnings;
  @override
  @JsonKey()
  final double totalSpent;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? defaultPayoutMethod;
  @override
  final String? bankAccountNumber;
  @override
  final String? bankName;
  @override
  final String? bankRoutingNumber;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WalletModel(userId: $userId, availableBalance: $availableBalance, pendingBalance: $pendingBalance, totalEarnings: $totalEarnings, totalSpent: $totalSpent, currency: $currency, defaultPayoutMethod: $defaultPayoutMethod, bankAccountNumber: $bankAccountNumber, bankName: $bankName, bankRoutingNumber: $bankRoutingNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.pendingBalance, pendingBalance) ||
                other.pendingBalance == pendingBalance) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.defaultPayoutMethod, defaultPayoutMethod) ||
                other.defaultPayoutMethod == defaultPayoutMethod) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankRoutingNumber, bankRoutingNumber) ||
                other.bankRoutingNumber == bankRoutingNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    availableBalance,
    pendingBalance,
    totalEarnings,
    totalSpent,
    currency,
    defaultPayoutMethod,
    bankAccountNumber,
    bankName,
    bankRoutingNumber,
    createdAt,
    updatedAt,
  );

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      __$$WalletModelImplCopyWithImpl<_$WalletModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletModelImplToJson(this);
  }
}

abstract class _WalletModel extends WalletModel {
  const factory _WalletModel({
    required final String userId,
    final double availableBalance,
    final double pendingBalance,
    final double totalEarnings,
    final double totalSpent,
    final String currency,
    final String? defaultPayoutMethod,
    final String? bankAccountNumber,
    final String? bankName,
    final String? bankRoutingNumber,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$WalletModelImpl;
  const _WalletModel._() : super._();

  factory _WalletModel.fromJson(Map<String, dynamic> json) =
      _$WalletModelImpl.fromJson;

  @override
  String get userId;
  @override
  double get availableBalance;
  @override
  double get pendingBalance;
  @override
  double get totalEarnings;
  @override
  double get totalSpent;
  @override
  String get currency;
  @override
  String? get defaultPayoutMethod;
  @override
  String? get bankAccountNumber;
  @override
  String? get bankName;
  @override
  String? get bankRoutingNumber;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WalletTransaction _$WalletTransactionFromJson(Map<String, dynamic> json) {
  return _WalletTransaction.fromJson(json);
}

/// @nodoc
mixin _$WalletTransaction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;
  String? get counterpartyId => throw _privateConstructorUsedError;
  String? get counterpartyName => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this WalletTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletTransactionCopyWith<WalletTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletTransactionCopyWith<$Res> {
  factory $WalletTransactionCopyWith(
    WalletTransaction value,
    $Res Function(WalletTransaction) then,
  ) = _$WalletTransactionCopyWithImpl<$Res, WalletTransaction>;
  @useResult
  $Res call({
    String id,
    String userId,
    TransactionType type,
    TransactionStatus status,
    double amount,
    String currency,
    String description,
    String? tripId,
    String? bookingId,
    String? paymentIntentId,
    String? counterpartyId,
    String? counterpartyName,
    String? failureReason,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$WalletTransactionCopyWithImpl<$Res, $Val extends WalletTransaction>
    implements $WalletTransactionCopyWith<$Res> {
  _$WalletTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = null,
    Object? tripId = freezed,
    Object? bookingId = freezed,
    Object? paymentIntentId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? failureReason = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: freezed == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingId: freezed == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentIntentId: freezed == paymentIntentId
                ? _value.paymentIntentId
                : paymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            counterpartyId: freezed == counterpartyId
                ? _value.counterpartyId
                : counterpartyId // ignore: cast_nullable_to_non_nullable
                      as String?,
            counterpartyName: freezed == counterpartyName
                ? _value.counterpartyName
                : counterpartyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            failureReason: freezed == failureReason
                ? _value.failureReason
                : failureReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalletTransactionImplCopyWith<$Res>
    implements $WalletTransactionCopyWith<$Res> {
  factory _$$WalletTransactionImplCopyWith(
    _$WalletTransactionImpl value,
    $Res Function(_$WalletTransactionImpl) then,
  ) = __$$WalletTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    TransactionType type,
    TransactionStatus status,
    double amount,
    String currency,
    String description,
    String? tripId,
    String? bookingId,
    String? paymentIntentId,
    String? counterpartyId,
    String? counterpartyName,
    String? failureReason,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$WalletTransactionImplCopyWithImpl<$Res>
    extends _$WalletTransactionCopyWithImpl<$Res, _$WalletTransactionImpl>
    implements _$$WalletTransactionImplCopyWith<$Res> {
  __$$WalletTransactionImplCopyWithImpl(
    _$WalletTransactionImpl _value,
    $Res Function(_$WalletTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WalletTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = null,
    Object? tripId = freezed,
    Object? bookingId = freezed,
    Object? paymentIntentId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? failureReason = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$WalletTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: freezed == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingId: freezed == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentIntentId: freezed == paymentIntentId
            ? _value.paymentIntentId
            : paymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        counterpartyId: freezed == counterpartyId
            ? _value.counterpartyId
            : counterpartyId // ignore: cast_nullable_to_non_nullable
                  as String?,
        counterpartyName: freezed == counterpartyName
            ? _value.counterpartyName
            : counterpartyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        failureReason: freezed == failureReason
            ? _value.failureReason
            : failureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletTransactionImpl implements _WalletTransaction {
  const _$WalletTransactionImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.description,
    this.tripId,
    this.bookingId,
    this.paymentIntentId,
    this.counterpartyId,
    this.counterpartyName,
    this.failureReason,
    required this.createdAt,
    this.completedAt,
  });

  factory _$WalletTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final TransactionType type;
  @override
  final TransactionStatus status;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String description;
  @override
  final String? tripId;
  @override
  final String? bookingId;
  @override
  final String? paymentIntentId;
  @override
  final String? counterpartyId;
  @override
  final String? counterpartyName;
  @override
  final String? failureReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'WalletTransaction(id: $id, userId: $userId, type: $type, status: $status, amount: $amount, currency: $currency, description: $description, tripId: $tripId, bookingId: $bookingId, paymentIntentId: $paymentIntentId, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, failureReason: $failureReason, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    status,
    amount,
    currency,
    description,
    tripId,
    bookingId,
    paymentIntentId,
    counterpartyId,
    counterpartyName,
    failureReason,
    createdAt,
    completedAt,
  );

  /// Create a copy of WalletTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletTransactionImplCopyWith<_$WalletTransactionImpl> get copyWith =>
      __$$WalletTransactionImplCopyWithImpl<_$WalletTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletTransactionImplToJson(this);
  }
}

abstract class _WalletTransaction implements WalletTransaction {
  const factory _WalletTransaction({
    required final String id,
    required final String userId,
    required final TransactionType type,
    required final TransactionStatus status,
    required final double amount,
    required final String currency,
    required final String description,
    final String? tripId,
    final String? bookingId,
    final String? paymentIntentId,
    final String? counterpartyId,
    final String? counterpartyName,
    final String? failureReason,
    required final DateTime createdAt,
    final DateTime? completedAt,
  }) = _$WalletTransactionImpl;

  factory _WalletTransaction.fromJson(Map<String, dynamic> json) =
      _$WalletTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  TransactionType get type;
  @override
  TransactionStatus get status;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get description;
  @override
  String? get tripId;
  @override
  String? get bookingId;
  @override
  String? get paymentIntentId;
  @override
  String? get counterpartyId;
  @override
  String? get counterpartyName;
  @override
  String? get failureReason;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of WalletTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletTransactionImplCopyWith<_$WalletTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PayoutRequest _$PayoutRequestFromJson(Map<String, dynamic> json) {
  return _PayoutRequest.fromJson(json);
}

/// @nodoc
mixin _$PayoutRequest {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  String get payoutMethod => throw _privateConstructorUsedError;
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;
  String? get processedBy => throw _privateConstructorUsedError;

  /// Serializes this PayoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayoutRequestCopyWith<PayoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutRequestCopyWith<$Res> {
  factory $PayoutRequestCopyWith(
    PayoutRequest value,
    $Res Function(PayoutRequest) then,
  ) = _$PayoutRequestCopyWithImpl<$Res, PayoutRequest>;
  @useResult
  $Res call({
    String id,
    String userId,
    double amount,
    String currency,
    TransactionStatus status,
    String payoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? failureReason,
    DateTime createdAt,
    DateTime? processedAt,
    String? processedBy,
  });
}

/// @nodoc
class _$PayoutRequestCopyWithImpl<$Res, $Val extends PayoutRequest>
    implements $PayoutRequestCopyWith<$Res> {
  _$PayoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? payoutMethod = null,
    Object? bankAccountNumber = freezed,
    Object? bankName = freezed,
    Object? failureReason = freezed,
    Object? createdAt = null,
    Object? processedAt = freezed,
    Object? processedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            payoutMethod: null == payoutMethod
                ? _value.payoutMethod
                : payoutMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            bankAccountNumber: freezed == bankAccountNumber
                ? _value.bankAccountNumber
                : bankAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankName: freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String?,
            failureReason: freezed == failureReason
                ? _value.failureReason
                : failureReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            processedAt: freezed == processedAt
                ? _value.processedAt
                : processedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            processedBy: freezed == processedBy
                ? _value.processedBy
                : processedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PayoutRequestImplCopyWith<$Res>
    implements $PayoutRequestCopyWith<$Res> {
  factory _$$PayoutRequestImplCopyWith(
    _$PayoutRequestImpl value,
    $Res Function(_$PayoutRequestImpl) then,
  ) = __$$PayoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    double amount,
    String currency,
    TransactionStatus status,
    String payoutMethod,
    String? bankAccountNumber,
    String? bankName,
    String? failureReason,
    DateTime createdAt,
    DateTime? processedAt,
    String? processedBy,
  });
}

/// @nodoc
class __$$PayoutRequestImplCopyWithImpl<$Res>
    extends _$PayoutRequestCopyWithImpl<$Res, _$PayoutRequestImpl>
    implements _$$PayoutRequestImplCopyWith<$Res> {
  __$$PayoutRequestImplCopyWithImpl(
    _$PayoutRequestImpl _value,
    $Res Function(_$PayoutRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? payoutMethod = null,
    Object? bankAccountNumber = freezed,
    Object? bankName = freezed,
    Object? failureReason = freezed,
    Object? createdAt = null,
    Object? processedAt = freezed,
    Object? processedBy = freezed,
  }) {
    return _then(
      _$PayoutRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        payoutMethod: null == payoutMethod
            ? _value.payoutMethod
            : payoutMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        bankAccountNumber: freezed == bankAccountNumber
            ? _value.bankAccountNumber
            : bankAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankName: freezed == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String?,
        failureReason: freezed == failureReason
            ? _value.failureReason
            : failureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        processedAt: freezed == processedAt
            ? _value.processedAt
            : processedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        processedBy: freezed == processedBy
            ? _value.processedBy
            : processedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PayoutRequestImpl implements _PayoutRequest {
  const _$PayoutRequestImpl({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.payoutMethod,
    this.bankAccountNumber,
    this.bankName,
    this.failureReason,
    required this.createdAt,
    this.processedAt,
    this.processedBy,
  });

  factory _$PayoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final TransactionStatus status;
  @override
  final String payoutMethod;
  @override
  final String? bankAccountNumber;
  @override
  final String? bankName;
  @override
  final String? failureReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime? processedAt;
  @override
  final String? processedBy;

  @override
  String toString() {
    return 'PayoutRequest(id: $id, userId: $userId, amount: $amount, currency: $currency, status: $status, payoutMethod: $payoutMethod, bankAccountNumber: $bankAccountNumber, bankName: $bankName, failureReason: $failureReason, createdAt: $createdAt, processedAt: $processedAt, processedBy: $processedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.payoutMethod, payoutMethod) ||
                other.payoutMethod == payoutMethod) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.processedBy, processedBy) ||
                other.processedBy == processedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    amount,
    currency,
    status,
    payoutMethod,
    bankAccountNumber,
    bankName,
    failureReason,
    createdAt,
    processedAt,
    processedBy,
  );

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutRequestImplCopyWith<_$PayoutRequestImpl> get copyWith =>
      __$$PayoutRequestImplCopyWithImpl<_$PayoutRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayoutRequestImplToJson(this);
  }
}

abstract class _PayoutRequest implements PayoutRequest {
  const factory _PayoutRequest({
    required final String id,
    required final String userId,
    required final double amount,
    required final String currency,
    required final TransactionStatus status,
    required final String payoutMethod,
    final String? bankAccountNumber,
    final String? bankName,
    final String? failureReason,
    required final DateTime createdAt,
    final DateTime? processedAt,
    final String? processedBy,
  }) = _$PayoutRequestImpl;

  factory _PayoutRequest.fromJson(Map<String, dynamic> json) =
      _$PayoutRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  TransactionStatus get status;
  @override
  String get payoutMethod;
  @override
  String? get bankAccountNumber;
  @override
  String? get bankName;
  @override
  String? get failureReason;
  @override
  DateTime get createdAt;
  @override
  DateTime? get processedAt;
  @override
  String? get processedBy;

  /// Create a copy of PayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayoutRequestImplCopyWith<_$PayoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
