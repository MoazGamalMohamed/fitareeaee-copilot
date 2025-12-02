// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get payerId => throw _privateConstructorUsedError;
  String get payeeId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get paymentMethod =>
      throw _privateConstructorUsedError; // 'card', 'wallet', 'bank_transfer', 'stripe'
  String get status =>
      throw _privateConstructorUsedError; // PaymentStatus values
  String? get transactionId => throw _privateConstructorUsedError;
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  String? get stripeTransferId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt =>
      throw _privateConstructorUsedError; // Escrow fields
  String get escrowStatus =>
      throw _privateConstructorUsedError; // EscrowStatus values
  DateTime? get escrowHeldAt => throw _privateConstructorUsedError;
  DateTime? get escrowReleasedAt =>
      throw _privateConstructorUsedError; // Fee breakdown
  double get platformFee => throw _privateConstructorUsedError;
  double get processingFee => throw _privateConstructorUsedError;
  double get netAmount =>
      throw _privateConstructorUsedError; // Amount after fees
  // Refund info
  String? get refundReason => throw _privateConstructorUsedError;
  DateTime? get refundedAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
    PaymentModel value,
    $Res Function(PaymentModel) then,
  ) = _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call({
    String id,
    String bookingId,
    String payerId,
    String payeeId,
    double amount,
    String currency,
    String paymentMethod,
    String status,
    String? transactionId,
    String? stripePaymentIntentId,
    String? stripeTransferId,
    DateTime createdAt,
    DateTime? completedAt,
    String escrowStatus,
    DateTime? escrowHeldAt,
    DateTime? escrowReleasedAt,
    double platformFee,
    double processingFee,
    double netAmount,
    String? refundReason,
    DateTime? refundedAt,
  });
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? payerId = null,
    Object? payeeId = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? stripeTransferId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? escrowStatus = null,
    Object? escrowHeldAt = freezed,
    Object? escrowReleasedAt = freezed,
    Object? platformFee = null,
    Object? processingFee = null,
    Object? netAmount = null,
    Object? refundReason = freezed,
    Object? refundedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String,
            payerId: null == payerId
                ? _value.payerId
                : payerId // ignore: cast_nullable_to_non_nullable
                      as String,
            payeeId: null == payeeId
                ? _value.payeeId
                : payeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripePaymentIntentId: freezed == stripePaymentIntentId
                ? _value.stripePaymentIntentId
                : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripeTransferId: freezed == stripeTransferId
                ? _value.stripeTransferId
                : stripeTransferId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            escrowStatus: null == escrowStatus
                ? _value.escrowStatus
                : escrowStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            escrowHeldAt: freezed == escrowHeldAt
                ? _value.escrowHeldAt
                : escrowHeldAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            escrowReleasedAt: freezed == escrowReleasedAt
                ? _value.escrowReleasedAt
                : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            platformFee: null == platformFee
                ? _value.platformFee
                : platformFee // ignore: cast_nullable_to_non_nullable
                      as double,
            processingFee: null == processingFee
                ? _value.processingFee
                : processingFee // ignore: cast_nullable_to_non_nullable
                      as double,
            netAmount: null == netAmount
                ? _value.netAmount
                : netAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            refundReason: freezed == refundReason
                ? _value.refundReason
                : refundReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            refundedAt: freezed == refundedAt
                ? _value.refundedAt
                : refundedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
    _$PaymentModelImpl value,
    $Res Function(_$PaymentModelImpl) then,
  ) = __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String bookingId,
    String payerId,
    String payeeId,
    double amount,
    String currency,
    String paymentMethod,
    String status,
    String? transactionId,
    String? stripePaymentIntentId,
    String? stripeTransferId,
    DateTime createdAt,
    DateTime? completedAt,
    String escrowStatus,
    DateTime? escrowHeldAt,
    DateTime? escrowReleasedAt,
    double platformFee,
    double processingFee,
    double netAmount,
    String? refundReason,
    DateTime? refundedAt,
  });
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
    _$PaymentModelImpl _value,
    $Res Function(_$PaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? payerId = null,
    Object? payeeId = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? stripeTransferId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? escrowStatus = null,
    Object? escrowHeldAt = freezed,
    Object? escrowReleasedAt = freezed,
    Object? platformFee = null,
    Object? processingFee = null,
    Object? netAmount = null,
    Object? refundReason = freezed,
    Object? refundedAt = freezed,
  }) {
    return _then(
      _$PaymentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String,
        payerId: null == payerId
            ? _value.payerId
            : payerId // ignore: cast_nullable_to_non_nullable
                  as String,
        payeeId: null == payeeId
            ? _value.payeeId
            : payeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripePaymentIntentId: freezed == stripePaymentIntentId
            ? _value.stripePaymentIntentId
            : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripeTransferId: freezed == stripeTransferId
            ? _value.stripeTransferId
            : stripeTransferId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        escrowStatus: null == escrowStatus
            ? _value.escrowStatus
            : escrowStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        escrowHeldAt: freezed == escrowHeldAt
            ? _value.escrowHeldAt
            : escrowHeldAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        escrowReleasedAt: freezed == escrowReleasedAt
            ? _value.escrowReleasedAt
            : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        platformFee: null == platformFee
            ? _value.platformFee
            : platformFee // ignore: cast_nullable_to_non_nullable
                  as double,
        processingFee: null == processingFee
            ? _value.processingFee
            : processingFee // ignore: cast_nullable_to_non_nullable
                  as double,
        netAmount: null == netAmount
            ? _value.netAmount
            : netAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        refundReason: freezed == refundReason
            ? _value.refundReason
            : refundReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        refundedAt: freezed == refundedAt
            ? _value.refundedAt
            : refundedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl({
    required this.id,
    required this.bookingId,
    required this.payerId,
    required this.payeeId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    this.stripePaymentIntentId,
    this.stripeTransferId,
    required this.createdAt,
    this.completedAt,
    this.escrowStatus = 'none',
    this.escrowHeldAt,
    this.escrowReleasedAt,
    this.platformFee = 0.0,
    this.processingFee = 0.0,
    this.netAmount = 0.0,
    this.refundReason,
    this.refundedAt,
  });

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String payerId;
  @override
  final String payeeId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String paymentMethod;
  // 'card', 'wallet', 'bank_transfer', 'stripe'
  @override
  final String status;
  // PaymentStatus values
  @override
  final String? transactionId;
  @override
  final String? stripePaymentIntentId;
  @override
  final String? stripeTransferId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  // Escrow fields
  @override
  @JsonKey()
  final String escrowStatus;
  // EscrowStatus values
  @override
  final DateTime? escrowHeldAt;
  @override
  final DateTime? escrowReleasedAt;
  // Fee breakdown
  @override
  @JsonKey()
  final double platformFee;
  @override
  @JsonKey()
  final double processingFee;
  @override
  @JsonKey()
  final double netAmount;
  // Amount after fees
  // Refund info
  @override
  final String? refundReason;
  @override
  final DateTime? refundedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, bookingId: $bookingId, payerId: $payerId, payeeId: $payeeId, amount: $amount, currency: $currency, paymentMethod: $paymentMethod, status: $status, transactionId: $transactionId, stripePaymentIntentId: $stripePaymentIntentId, stripeTransferId: $stripeTransferId, createdAt: $createdAt, completedAt: $completedAt, escrowStatus: $escrowStatus, escrowHeldAt: $escrowHeldAt, escrowReleasedAt: $escrowReleasedAt, platformFee: $platformFee, processingFee: $processingFee, netAmount: $netAmount, refundReason: $refundReason, refundedAt: $refundedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.payerId, payerId) || other.payerId == payerId) &&
            (identical(other.payeeId, payeeId) || other.payeeId == payeeId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.stripeTransferId, stripeTransferId) ||
                other.stripeTransferId == stripeTransferId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.escrowStatus, escrowStatus) ||
                other.escrowStatus == escrowStatus) &&
            (identical(other.escrowHeldAt, escrowHeldAt) ||
                other.escrowHeldAt == escrowHeldAt) &&
            (identical(other.escrowReleasedAt, escrowReleasedAt) ||
                other.escrowReleasedAt == escrowReleasedAt) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.processingFee, processingFee) ||
                other.processingFee == processingFee) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    bookingId,
    payerId,
    payeeId,
    amount,
    currency,
    paymentMethod,
    status,
    transactionId,
    stripePaymentIntentId,
    stripeTransferId,
    createdAt,
    completedAt,
    escrowStatus,
    escrowHeldAt,
    escrowReleasedAt,
    platformFee,
    processingFee,
    netAmount,
    refundReason,
    refundedAt,
  ]);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(this);
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel({
    required final String id,
    required final String bookingId,
    required final String payerId,
    required final String payeeId,
    required final double amount,
    required final String currency,
    required final String paymentMethod,
    required final String status,
    final String? transactionId,
    final String? stripePaymentIntentId,
    final String? stripeTransferId,
    required final DateTime createdAt,
    final DateTime? completedAt,
    final String escrowStatus,
    final DateTime? escrowHeldAt,
    final DateTime? escrowReleasedAt,
    final double platformFee,
    final double processingFee,
    final double netAmount,
    final String? refundReason,
    final DateTime? refundedAt,
  }) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get payerId;
  @override
  String get payeeId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get paymentMethod; // 'card', 'wallet', 'bank_transfer', 'stripe'
  @override
  String get status; // PaymentStatus values
  @override
  String? get transactionId;
  @override
  String? get stripePaymentIntentId;
  @override
  String? get stripeTransferId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt; // Escrow fields
  @override
  String get escrowStatus; // EscrowStatus values
  @override
  DateTime? get escrowHeldAt;
  @override
  DateTime? get escrowReleasedAt; // Fee breakdown
  @override
  double get platformFee;
  @override
  double get processingFee;
  @override
  double get netAmount; // Amount after fees
  // Refund info
  @override
  String? get refundReason;
  @override
  DateTime? get refundedAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
