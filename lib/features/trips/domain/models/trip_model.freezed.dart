// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripModel _$TripModelFromJson(Map<String, dynamic> json) {
  return _TripModel.fromJson(json);
}

/// @nodoc
mixin _$TripModel {
  String get id => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get startLocation => throw _privateConstructorUsedError;
  String get endLocation => throw _privateConstructorUsedError;
  double get startLatitude => throw _privateConstructorUsedError;
  double get startLongitude => throw _privateConstructorUsedError;
  double get endLatitude => throw _privateConstructorUsedError;
  double get endLongitude => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError; // in km
  double get estimatedDuration =>
      throw _privateConstructorUsedError; // in minutes
  double get pricePerSeat => throw _privateConstructorUsedError;
  int get totalSeats => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  List<String> get passengerIds => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'in_progress', 'completed', 'cancelled'
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TripModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripModelCopyWith<TripModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripModelCopyWith<$Res> {
  factory $TripModelCopyWith(TripModel value, $Res Function(TripModel) then) =
      _$TripModelCopyWithImpl<$Res, TripModel>;
  @useResult
  $Res call({
    String id,
    String driverId,
    String startLocation,
    String endLocation,
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
    DateTime departureTime,
    double distance,
    double estimatedDuration,
    double pricePerSeat,
    int totalSeats,
    int availableSeats,
    List<String> passengerIds,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TripModelCopyWithImpl<$Res, $Val extends TripModel>
    implements $TripModelCopyWith<$Res> {
  _$TripModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? startLocation = null,
    Object? endLocation = null,
    Object? startLatitude = null,
    Object? startLongitude = null,
    Object? endLatitude = null,
    Object? endLongitude = null,
    Object? departureTime = null,
    Object? distance = null,
    Object? estimatedDuration = null,
    Object? pricePerSeat = null,
    Object? totalSeats = null,
    Object? availableSeats = null,
    Object? passengerIds = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: null == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String,
            startLocation: null == startLocation
                ? _value.startLocation
                : startLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            endLocation: null == endLocation
                ? _value.endLocation
                : endLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            startLatitude: null == startLatitude
                ? _value.startLatitude
                : startLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            startLongitude: null == startLongitude
                ? _value.startLongitude
                : startLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            endLatitude: null == endLatitude
                ? _value.endLatitude
                : endLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            endLongitude: null == endLongitude
                ? _value.endLongitude
                : endLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            distance: null == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedDuration: null == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as double,
            pricePerSeat: null == pricePerSeat
                ? _value.pricePerSeat
                : pricePerSeat // ignore: cast_nullable_to_non_nullable
                      as double,
            totalSeats: null == totalSeats
                ? _value.totalSeats
                : totalSeats // ignore: cast_nullable_to_non_nullable
                      as int,
            availableSeats: null == availableSeats
                ? _value.availableSeats
                : availableSeats // ignore: cast_nullable_to_non_nullable
                      as int,
            passengerIds: null == passengerIds
                ? _value.passengerIds
                : passengerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$TripModelImplCopyWith<$Res>
    implements $TripModelCopyWith<$Res> {
  factory _$$TripModelImplCopyWith(
    _$TripModelImpl value,
    $Res Function(_$TripModelImpl) then,
  ) = __$$TripModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String driverId,
    String startLocation,
    String endLocation,
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
    DateTime departureTime,
    double distance,
    double estimatedDuration,
    double pricePerSeat,
    int totalSeats,
    int availableSeats,
    List<String> passengerIds,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TripModelImplCopyWithImpl<$Res>
    extends _$TripModelCopyWithImpl<$Res, _$TripModelImpl>
    implements _$$TripModelImplCopyWith<$Res> {
  __$$TripModelImplCopyWithImpl(
    _$TripModelImpl _value,
    $Res Function(_$TripModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = null,
    Object? startLocation = null,
    Object? endLocation = null,
    Object? startLatitude = null,
    Object? startLongitude = null,
    Object? endLatitude = null,
    Object? endLongitude = null,
    Object? departureTime = null,
    Object? distance = null,
    Object? estimatedDuration = null,
    Object? pricePerSeat = null,
    Object? totalSeats = null,
    Object? availableSeats = null,
    Object? passengerIds = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TripModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: null == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String,
        startLocation: null == startLocation
            ? _value.startLocation
            : startLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        endLocation: null == endLocation
            ? _value.endLocation
            : endLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        startLatitude: null == startLatitude
            ? _value.startLatitude
            : startLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        startLongitude: null == startLongitude
            ? _value.startLongitude
            : startLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        endLatitude: null == endLatitude
            ? _value.endLatitude
            : endLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        endLongitude: null == endLongitude
            ? _value.endLongitude
            : endLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        distance: null == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedDuration: null == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as double,
        pricePerSeat: null == pricePerSeat
            ? _value.pricePerSeat
            : pricePerSeat // ignore: cast_nullable_to_non_nullable
                  as double,
        totalSeats: null == totalSeats
            ? _value.totalSeats
            : totalSeats // ignore: cast_nullable_to_non_nullable
                  as int,
        availableSeats: null == availableSeats
            ? _value.availableSeats
            : availableSeats // ignore: cast_nullable_to_non_nullable
                  as int,
        passengerIds: null == passengerIds
            ? _value._passengerIds
            : passengerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TripModelImpl implements _TripModel {
  const _$TripModelImpl({
    required this.id,
    required this.driverId,
    required this.startLocation,
    required this.endLocation,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.departureTime,
    required this.distance,
    required this.estimatedDuration,
    required this.pricePerSeat,
    required this.totalSeats,
    required this.availableSeats,
    required final List<String> passengerIds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : _passengerIds = passengerIds;

  factory _$TripModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripModelImplFromJson(json);

  @override
  final String id;
  @override
  final String driverId;
  @override
  final String startLocation;
  @override
  final String endLocation;
  @override
  final double startLatitude;
  @override
  final double startLongitude;
  @override
  final double endLatitude;
  @override
  final double endLongitude;
  @override
  final DateTime departureTime;
  @override
  final double distance;
  // in km
  @override
  final double estimatedDuration;
  // in minutes
  @override
  final double pricePerSeat;
  @override
  final int totalSeats;
  @override
  final int availableSeats;
  final List<String> _passengerIds;
  @override
  List<String> get passengerIds {
    if (_passengerIds is EqualUnmodifiableListView) return _passengerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengerIds);
  }

  @override
  final String status;
  // 'pending', 'in_progress', 'completed', 'cancelled'
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TripModel(id: $id, driverId: $driverId, startLocation: $startLocation, endLocation: $endLocation, startLatitude: $startLatitude, startLongitude: $startLongitude, endLatitude: $endLatitude, endLongitude: $endLongitude, departureTime: $departureTime, distance: $distance, estimatedDuration: $estimatedDuration, pricePerSeat: $pricePerSeat, totalSeats: $totalSeats, availableSeats: $availableSeats, passengerIds: $passengerIds, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.startLocation, startLocation) ||
                other.startLocation == startLocation) &&
            (identical(other.endLocation, endLocation) ||
                other.endLocation == endLocation) &&
            (identical(other.startLatitude, startLatitude) ||
                other.startLatitude == startLatitude) &&
            (identical(other.startLongitude, startLongitude) ||
                other.startLongitude == startLongitude) &&
            (identical(other.endLatitude, endLatitude) ||
                other.endLatitude == endLatitude) &&
            (identical(other.endLongitude, endLongitude) ||
                other.endLongitude == endLongitude) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.totalSeats, totalSeats) ||
                other.totalSeats == totalSeats) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            const DeepCollectionEquality().equals(
              other._passengerIds,
              _passengerIds,
            ) &&
            (identical(other.status, status) || other.status == status) &&
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
    driverId,
    startLocation,
    endLocation,
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
    departureTime,
    distance,
    estimatedDuration,
    pricePerSeat,
    totalSeats,
    availableSeats,
    const DeepCollectionEquality().hash(_passengerIds),
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      __$$TripModelImplCopyWithImpl<_$TripModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripModelImplToJson(this);
  }
}

abstract class _TripModel implements TripModel {
  const factory _TripModel({
    required final String id,
    required final String driverId,
    required final String startLocation,
    required final String endLocation,
    required final double startLatitude,
    required final double startLongitude,
    required final double endLatitude,
    required final double endLongitude,
    required final DateTime departureTime,
    required final double distance,
    required final double estimatedDuration,
    required final double pricePerSeat,
    required final int totalSeats,
    required final int availableSeats,
    required final List<String> passengerIds,
    required final String status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TripModelImpl;

  factory _TripModel.fromJson(Map<String, dynamic> json) =
      _$TripModelImpl.fromJson;

  @override
  String get id;
  @override
  String get driverId;
  @override
  String get startLocation;
  @override
  String get endLocation;
  @override
  double get startLatitude;
  @override
  double get startLongitude;
  @override
  double get endLatitude;
  @override
  double get endLongitude;
  @override
  DateTime get departureTime;
  @override
  double get distance; // in km
  @override
  double get estimatedDuration; // in minutes
  @override
  double get pricePerSeat;
  @override
  int get totalSeats;
  @override
  int get availableSeats;
  @override
  List<String> get passengerIds;
  @override
  String get status; // 'pending', 'in_progress', 'completed', 'cancelled'
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
