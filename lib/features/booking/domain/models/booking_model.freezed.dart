// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get passengerId => throw _privateConstructorUsedError;
  String get driverId =>
      throw _privateConstructorUsedError; // Driver who owns the trip
  int get seatsBooked => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'confirmed', 'completed', 'cancelled', 'paid'
  String get paymentStatus =>
      throw _privateConstructorUsedError; // 'unpaid', 'paid', 'refunded', 'escrow'
  String? get pickupLocation => throw _privateConstructorUsedError;
  String? get dropoffLocation => throw _privateConstructorUsedError;
  DateTime? get pickupTime => throw _privateConstructorUsedError;
  DateTime? get dropoffTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
    BookingModel value,
    $Res Function(BookingModel) then,
  ) = _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call({
    String id,
    String tripId,
    String passengerId,
    String driverId,
    int seatsBooked,
    double totalPrice,
    String status,
    String paymentStatus,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? pickupTime,
    DateTime? dropoffTime,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? passengerId = null,
    Object? driverId = null,
    Object? seatsBooked = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? pickupTime = freezed,
    Object? dropoffTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: null == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String,
            passengerId: null == passengerId
                ? _value.passengerId
                : passengerId // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: null == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String,
            seatsBooked: null == seatsBooked
                ? _value.seatsBooked
                : seatsBooked // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLocation: freezed == pickupLocation
                ? _value.pickupLocation
                : pickupLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            dropoffLocation: freezed == dropoffLocation
                ? _value.dropoffLocation
                : dropoffLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickupTime: freezed == pickupTime
                ? _value.pickupTime
                : pickupTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dropoffTime: freezed == dropoffTime
                ? _value.dropoffTime
                : dropoffTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
    _$BookingModelImpl value,
    $Res Function(_$BookingModelImpl) then,
  ) = __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tripId,
    String passengerId,
    String driverId,
    int seatsBooked,
    double totalPrice,
    String status,
    String paymentStatus,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? pickupTime,
    DateTime? dropoffTime,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
    _$BookingModelImpl _value,
    $Res Function(_$BookingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? passengerId = null,
    Object? driverId = null,
    Object? seatsBooked = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? pickupTime = freezed,
    Object? dropoffTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BookingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        passengerId: null == passengerId
            ? _value.passengerId
            : passengerId // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: null == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String,
        seatsBooked: null == seatsBooked
            ? _value.seatsBooked
            : seatsBooked // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLocation: freezed == pickupLocation
            ? _value.pickupLocation
            : pickupLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        dropoffLocation: freezed == dropoffLocation
            ? _value.dropoffLocation
            : dropoffLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickupTime: freezed == pickupTime
            ? _value.pickupTime
            : pickupTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dropoffTime: freezed == dropoffTime
            ? _value.dropoffTime
            : dropoffTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.driverId,
    required this.seatsBooked,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupTime,
    required this.dropoffTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String passengerId;
  @override
  final String driverId;
  // Driver who owns the trip
  @override
  final int seatsBooked;
  @override
  final double totalPrice;
  @override
  final String status;
  // 'pending', 'confirmed', 'completed', 'cancelled', 'paid'
  @override
  final String paymentStatus;
  // 'unpaid', 'paid', 'refunded', 'escrow'
  @override
  final String? pickupLocation;
  @override
  final String? dropoffLocation;
  @override
  final DateTime? pickupTime;
  @override
  final DateTime? dropoffTime;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, tripId: $tripId, passengerId: $passengerId, driverId: $driverId, seatsBooked: $seatsBooked, totalPrice: $totalPrice, status: $status, paymentStatus: $paymentStatus, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, pickupTime: $pickupTime, dropoffTime: $dropoffTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.passengerId, passengerId) ||
                other.passengerId == passengerId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.seatsBooked, seatsBooked) ||
                other.seatsBooked == seatsBooked) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.dropoffLocation, dropoffLocation) ||
                other.dropoffLocation == dropoffLocation) &&
            (identical(other.pickupTime, pickupTime) ||
                other.pickupTime == pickupTime) &&
            (identical(other.dropoffTime, dropoffTime) ||
                other.dropoffTime == dropoffTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tripId,
    passengerId,
    driverId,
    seatsBooked,
    totalPrice,
    status,
    paymentStatus,
    pickupLocation,
    dropoffLocation,
    pickupTime,
    dropoffTime,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(this);
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel({
    required final String id,
    required final String tripId,
    required final String passengerId,
    required final String driverId,
    required final int seatsBooked,
    required final double totalPrice,
    required final String status,
    required final String paymentStatus,
    required final String? pickupLocation,
    required final String? dropoffLocation,
    required final DateTime? pickupTime,
    required final DateTime? dropoffTime,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get passengerId;
  @override
  String get driverId; // Driver who owns the trip
  @override
  int get seatsBooked;
  @override
  double get totalPrice;
  @override
  String get status; // 'pending', 'confirmed', 'completed', 'cancelled', 'paid'
  @override
  String get paymentStatus; // 'unpaid', 'paid', 'refunded', 'escrow'
  @override
  String? get pickupLocation;
  @override
  String? get dropoffLocation;
  @override
  DateTime? get pickupTime;
  @override
  DateTime? get dropoffTime;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
