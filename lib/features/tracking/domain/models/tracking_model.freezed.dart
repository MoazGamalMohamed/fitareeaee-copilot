// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LiveLocation _$LiveLocationFromJson(Map<String, dynamic> json) {
  return _LiveLocation.fromJson(json);
}

/// @nodoc
mixin _$LiveLocation {
  String get oderId => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this LiveLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LiveLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiveLocationCopyWith<LiveLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveLocationCopyWith<$Res> {
  factory $LiveLocationCopyWith(
    LiveLocation value,
    $Res Function(LiveLocation) then,
  ) = _$LiveLocationCopyWithImpl<$Res, LiveLocation>;
  @useResult
  $Res call({
    String oderId,
    String tripId,
    double latitude,
    double longitude,
    double? speed,
    double? heading,
    double? accuracy,
    DateTime timestamp,
  });
}

/// @nodoc
class _$LiveLocationCopyWithImpl<$Res, $Val extends LiveLocation>
    implements $LiveLocationCopyWith<$Res> {
  _$LiveLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LiveLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? tripId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? accuracy = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            oderId: null == oderId
                ? _value.oderId
                : oderId // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: null == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            speed: freezed == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double?,
            heading: freezed == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as double?,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LiveLocationImplCopyWith<$Res>
    implements $LiveLocationCopyWith<$Res> {
  factory _$$LiveLocationImplCopyWith(
    _$LiveLocationImpl value,
    $Res Function(_$LiveLocationImpl) then,
  ) = __$$LiveLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String oderId,
    String tripId,
    double latitude,
    double longitude,
    double? speed,
    double? heading,
    double? accuracy,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$LiveLocationImplCopyWithImpl<$Res>
    extends _$LiveLocationCopyWithImpl<$Res, _$LiveLocationImpl>
    implements _$$LiveLocationImplCopyWith<$Res> {
  __$$LiveLocationImplCopyWithImpl(
    _$LiveLocationImpl _value,
    $Res Function(_$LiveLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LiveLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? tripId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? accuracy = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$LiveLocationImpl(
        oderId: null == oderId
            ? _value.oderId
            : oderId // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        speed: freezed == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double?,
        heading: freezed == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as double?,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveLocationImpl implements _LiveLocation {
  const _$LiveLocationImpl({
    required this.oderId,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    this.accuracy,
    required this.timestamp,
  });

  factory _$LiveLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveLocationImplFromJson(json);

  @override
  final String oderId;
  @override
  final String tripId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? speed;
  @override
  final double? heading;
  @override
  final double? accuracy;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'LiveLocation(oderId: $oderId, tripId: $tripId, latitude: $latitude, longitude: $longitude, speed: $speed, heading: $heading, accuracy: $accuracy, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveLocationImpl &&
            (identical(other.oderId, oderId) || other.oderId == oderId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    oderId,
    tripId,
    latitude,
    longitude,
    speed,
    heading,
    accuracy,
    timestamp,
  );

  /// Create a copy of LiveLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveLocationImplCopyWith<_$LiveLocationImpl> get copyWith =>
      __$$LiveLocationImplCopyWithImpl<_$LiveLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveLocationImplToJson(this);
  }
}

abstract class _LiveLocation implements LiveLocation {
  const factory _LiveLocation({
    required final String oderId,
    required final String tripId,
    required final double latitude,
    required final double longitude,
    final double? speed,
    final double? heading,
    final double? accuracy,
    required final DateTime timestamp,
  }) = _$LiveLocationImpl;

  factory _LiveLocation.fromJson(Map<String, dynamic> json) =
      _$LiveLocationImpl.fromJson;

  @override
  String get oderId;
  @override
  String get tripId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get speed;
  @override
  double? get heading;
  @override
  double? get accuracy;
  @override
  DateTime get timestamp;

  /// Create a copy of LiveLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiveLocationImplCopyWith<_$LiveLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripTracking _$TripTrackingFromJson(Map<String, dynamic> json) {
  return _TripTracking.fromJson(json);
}

/// @nodoc
mixin _$TripTracking {
  String get tripId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  TrackingStatus get status => throw _privateConstructorUsedError;
  LiveLocation? get currentLocation => throw _privateConstructorUsedError;
  List<String> get sharedWithUserIds => throw _privateConstructorUsedError;
  double? get originLatitude => throw _privateConstructorUsedError;
  double? get originLongitude => throw _privateConstructorUsedError;
  double? get destinationLatitude => throw _privateConstructorUsedError;
  double? get destinationLongitude => throw _privateConstructorUsedError;
  double? get estimatedDistanceKm => throw _privateConstructorUsedError;
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TripTracking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripTrackingCopyWith<TripTracking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripTrackingCopyWith<$Res> {
  factory $TripTrackingCopyWith(
    TripTracking value,
    $Res Function(TripTracking) then,
  ) = _$TripTrackingCopyWithImpl<$Res, TripTracking>;
  @useResult
  $Res call({
    String tripId,
    String driverId,
    TrackingStatus status,
    LiveLocation? currentLocation,
    List<String> sharedWithUserIds,
    double? originLatitude,
    double? originLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    double? estimatedDistanceKm,
    int? estimatedDurationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $LiveLocationCopyWith<$Res>? get currentLocation;
}

/// @nodoc
class _$TripTrackingCopyWithImpl<$Res, $Val extends TripTracking>
    implements $TripTrackingCopyWith<$Res> {
  _$TripTrackingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? driverId = null,
    Object? status = null,
    Object? currentLocation = freezed,
    Object? sharedWithUserIds = null,
    Object? originLatitude = freezed,
    Object? originLongitude = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? estimatedDistanceKm = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            tripId: null == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: null == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TrackingStatus,
            currentLocation: freezed == currentLocation
                ? _value.currentLocation
                : currentLocation // ignore: cast_nullable_to_non_nullable
                      as LiveLocation?,
            sharedWithUserIds: null == sharedWithUserIds
                ? _value.sharedWithUserIds
                : sharedWithUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            originLatitude: freezed == originLatitude
                ? _value.originLatitude
                : originLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            originLongitude: freezed == originLongitude
                ? _value.originLongitude
                : originLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLatitude: freezed == destinationLatitude
                ? _value.destinationLatitude
                : destinationLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLongitude: freezed == destinationLongitude
                ? _value.destinationLongitude
                : destinationLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            estimatedDistanceKm: freezed == estimatedDistanceKm
                ? _value.estimatedDistanceKm
                : estimatedDistanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            estimatedDurationMinutes: freezed == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LiveLocationCopyWith<$Res>? get currentLocation {
    if (_value.currentLocation == null) {
      return null;
    }

    return $LiveLocationCopyWith<$Res>(_value.currentLocation!, (value) {
      return _then(_value.copyWith(currentLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripTrackingImplCopyWith<$Res>
    implements $TripTrackingCopyWith<$Res> {
  factory _$$TripTrackingImplCopyWith(
    _$TripTrackingImpl value,
    $Res Function(_$TripTrackingImpl) then,
  ) = __$$TripTrackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tripId,
    String driverId,
    TrackingStatus status,
    LiveLocation? currentLocation,
    List<String> sharedWithUserIds,
    double? originLatitude,
    double? originLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    double? estimatedDistanceKm,
    int? estimatedDurationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $LiveLocationCopyWith<$Res>? get currentLocation;
}

/// @nodoc
class __$$TripTrackingImplCopyWithImpl<$Res>
    extends _$TripTrackingCopyWithImpl<$Res, _$TripTrackingImpl>
    implements _$$TripTrackingImplCopyWith<$Res> {
  __$$TripTrackingImplCopyWithImpl(
    _$TripTrackingImpl _value,
    $Res Function(_$TripTrackingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? driverId = null,
    Object? status = null,
    Object? currentLocation = freezed,
    Object? sharedWithUserIds = null,
    Object? originLatitude = freezed,
    Object? originLongitude = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? estimatedDistanceKm = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TripTrackingImpl(
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: null == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TrackingStatus,
        currentLocation: freezed == currentLocation
            ? _value.currentLocation
            : currentLocation // ignore: cast_nullable_to_non_nullable
                  as LiveLocation?,
        sharedWithUserIds: null == sharedWithUserIds
            ? _value._sharedWithUserIds
            : sharedWithUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        originLatitude: freezed == originLatitude
            ? _value.originLatitude
            : originLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        originLongitude: freezed == originLongitude
            ? _value.originLongitude
            : originLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLatitude: freezed == destinationLatitude
            ? _value.destinationLatitude
            : destinationLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLongitude: freezed == destinationLongitude
            ? _value.destinationLongitude
            : destinationLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        estimatedDistanceKm: freezed == estimatedDistanceKm
            ? _value.estimatedDistanceKm
            : estimatedDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        estimatedDurationMinutes: freezed == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
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
class _$TripTrackingImpl extends _TripTracking {
  const _$TripTrackingImpl({
    required this.tripId,
    required this.driverId,
    required this.status,
    this.currentLocation,
    final List<String> sharedWithUserIds = const [],
    this.originLatitude,
    this.originLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.estimatedDistanceKm,
    this.estimatedDurationMinutes,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : _sharedWithUserIds = sharedWithUserIds,
       super._();

  factory _$TripTrackingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripTrackingImplFromJson(json);

  @override
  final String tripId;
  @override
  final String driverId;
  @override
  final TrackingStatus status;
  @override
  final LiveLocation? currentLocation;
  final List<String> _sharedWithUserIds;
  @override
  @JsonKey()
  List<String> get sharedWithUserIds {
    if (_sharedWithUserIds is EqualUnmodifiableListView)
      return _sharedWithUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWithUserIds);
  }

  @override
  final double? originLatitude;
  @override
  final double? originLongitude;
  @override
  final double? destinationLatitude;
  @override
  final double? destinationLongitude;
  @override
  final double? estimatedDistanceKm;
  @override
  final int? estimatedDurationMinutes;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TripTracking(tripId: $tripId, driverId: $driverId, status: $status, currentLocation: $currentLocation, sharedWithUserIds: $sharedWithUserIds, originLatitude: $originLatitude, originLongitude: $originLongitude, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude, estimatedDistanceKm: $estimatedDistanceKm, estimatedDurationMinutes: $estimatedDurationMinutes, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripTrackingImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            const DeepCollectionEquality().equals(
              other._sharedWithUserIds,
              _sharedWithUserIds,
            ) &&
            (identical(other.originLatitude, originLatitude) ||
                other.originLatitude == originLatitude) &&
            (identical(other.originLongitude, originLongitude) ||
                other.originLongitude == originLongitude) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude) &&
            (identical(other.estimatedDistanceKm, estimatedDistanceKm) ||
                other.estimatedDistanceKm == estimatedDistanceKm) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tripId,
    driverId,
    status,
    currentLocation,
    const DeepCollectionEquality().hash(_sharedWithUserIds),
    originLatitude,
    originLongitude,
    destinationLatitude,
    destinationLongitude,
    estimatedDistanceKm,
    estimatedDurationMinutes,
    startedAt,
    completedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripTrackingImplCopyWith<_$TripTrackingImpl> get copyWith =>
      __$$TripTrackingImplCopyWithImpl<_$TripTrackingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripTrackingImplToJson(this);
  }
}

abstract class _TripTracking extends TripTracking {
  const factory _TripTracking({
    required final String tripId,
    required final String driverId,
    required final TrackingStatus status,
    final LiveLocation? currentLocation,
    final List<String> sharedWithUserIds,
    final double? originLatitude,
    final double? originLongitude,
    final double? destinationLatitude,
    final double? destinationLongitude,
    final double? estimatedDistanceKm,
    final int? estimatedDurationMinutes,
    final DateTime? startedAt,
    final DateTime? completedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TripTrackingImpl;
  const _TripTracking._() : super._();

  factory _TripTracking.fromJson(Map<String, dynamic> json) =
      _$TripTrackingImpl.fromJson;

  @override
  String get tripId;
  @override
  String get driverId;
  @override
  TrackingStatus get status;
  @override
  LiveLocation? get currentLocation;
  @override
  List<String> get sharedWithUserIds;
  @override
  double? get originLatitude;
  @override
  double? get originLongitude;
  @override
  double? get destinationLatitude;
  @override
  double? get destinationLongitude;
  @override
  double? get estimatedDistanceKm;
  @override
  int? get estimatedDurationMinutes;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TripTracking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripTrackingImplCopyWith<_$TripTrackingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationHistory _$LocationHistoryFromJson(Map<String, dynamic> json) {
  return _LocationHistory.fromJson(json);
}

/// @nodoc
mixin _$LocationHistory {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this LocationHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationHistoryCopyWith<LocationHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationHistoryCopyWith<$Res> {
  factory $LocationHistoryCopyWith(
    LocationHistory value,
    $Res Function(LocationHistory) then,
  ) = _$LocationHistoryCopyWithImpl<$Res, LocationHistory>;
  @useResult
  $Res call({
    String id,
    String tripId,
    String userId,
    double latitude,
    double longitude,
    double? speed,
    double? heading,
    DateTime timestamp,
  });
}

/// @nodoc
class _$LocationHistoryCopyWithImpl<$Res, $Val extends LocationHistory>
    implements $LocationHistoryCopyWith<$Res> {
  _$LocationHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = null,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            speed: freezed == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double?,
            heading: freezed == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as double?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationHistoryImplCopyWith<$Res>
    implements $LocationHistoryCopyWith<$Res> {
  factory _$$LocationHistoryImplCopyWith(
    _$LocationHistoryImpl value,
    $Res Function(_$LocationHistoryImpl) then,
  ) = __$$LocationHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tripId,
    String userId,
    double latitude,
    double longitude,
    double? speed,
    double? heading,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$LocationHistoryImplCopyWithImpl<$Res>
    extends _$LocationHistoryCopyWithImpl<$Res, _$LocationHistoryImpl>
    implements _$$LocationHistoryImplCopyWith<$Res> {
  __$$LocationHistoryImplCopyWithImpl(
    _$LocationHistoryImpl _value,
    $Res Function(_$LocationHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$LocationHistoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        speed: freezed == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double?,
        heading: freezed == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as double?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationHistoryImpl implements _LocationHistory {
  const _$LocationHistoryImpl({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    required this.timestamp,
  });

  factory _$LocationHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String userId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? speed;
  @override
  final double? heading;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'LocationHistory(id: $id, tripId: $tripId, userId: $userId, latitude: $latitude, longitude: $longitude, speed: $speed, heading: $heading, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tripId,
    userId,
    latitude,
    longitude,
    speed,
    heading,
    timestamp,
  );

  /// Create a copy of LocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationHistoryImplCopyWith<_$LocationHistoryImpl> get copyWith =>
      __$$LocationHistoryImplCopyWithImpl<_$LocationHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationHistoryImplToJson(this);
  }
}

abstract class _LocationHistory implements LocationHistory {
  const factory _LocationHistory({
    required final String id,
    required final String tripId,
    required final String userId,
    required final double latitude,
    required final double longitude,
    final double? speed,
    final double? heading,
    required final DateTime timestamp,
  }) = _$LocationHistoryImpl;

  factory _LocationHistory.fromJson(Map<String, dynamic> json) =
      _$LocationHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get userId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get speed;
  @override
  double? get heading;
  @override
  DateTime get timestamp;

  /// Create a copy of LocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationHistoryImplCopyWith<_$LocationHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
