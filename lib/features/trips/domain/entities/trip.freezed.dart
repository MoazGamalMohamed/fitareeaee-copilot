// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError; // 'person' or 'package'
  @JsonKey(name: 'direction')
  String get direction => throw _privateConstructorUsedError; // 'offer' or 'request'
  String get driverId => throw _privateConstructorUsedError;
  String? get passengerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_address')
  String get originAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_address')
  String get destinationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_lat')
  double get originLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_lng')
  double get originLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_lat')
  double get destinationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_lng')
  double get destinationLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_time')
  DateTime get departureTime => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError; // km
  @JsonKey(name: 'estimated_duration')
  int get estimatedDuration => throw _privateConstructorUsedError; // minutes
  @JsonKey(name: 'price_per_seat')
  double get pricePerSeat => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_seats')
  int get totalSeats => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_seats')
  int get availableSeats => throw _privateConstructorUsedError;
  @JsonKey(name: 'passenger_ids')
  List<String> get passengerIds => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get allowPets => throw _privateConstructorUsedError;
  bool get allowSmoking => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'direction') String direction,
    String driverId,
    String? passengerId,
    @JsonKey(name: 'origin_address') String originAddress,
    @JsonKey(name: 'destination_address') String destinationAddress,
    @JsonKey(name: 'origin_lat') double originLat,
    @JsonKey(name: 'origin_lng') double originLng,
    @JsonKey(name: 'destination_lat') double destinationLat,
    @JsonKey(name: 'destination_lng') double destinationLng,
    @JsonKey(name: 'departure_time') DateTime departureTime,
    double distance,
    @JsonKey(name: 'estimated_duration') int estimatedDuration,
    @JsonKey(name: 'price_per_seat') double pricePerSeat,
    @JsonKey(name: 'total_seats') int totalSeats,
    @JsonKey(name: 'available_seats') int availableSeats,
    @JsonKey(name: 'passenger_ids') List<String> passengerIds,
    String status,
    String? description,
    bool allowPets,
    bool allowSmoking,
    List<String> amenities,
    Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? direction = null,
    Object? driverId = null,
    Object? passengerId = freezed,
    Object? originAddress = null,
    Object? destinationAddress = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destinationLat = null,
    Object? destinationLng = null,
    Object? departureTime = null,
    Object? distance = null,
    Object? estimatedDuration = null,
    Object? pricePerSeat = null,
    Object? totalSeats = null,
    Object? availableSeats = null,
    Object? passengerIds = null,
    Object? status = null,
    Object? description = freezed,
    Object? allowPets = null,
    Object? allowSmoking = null,
    Object? amenities = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: null == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String,
            passengerId: freezed == passengerId
                ? _value.passengerId
                : passengerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            originAddress: null == originAddress
                ? _value.originAddress
                : originAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationAddress: null == destinationAddress
                ? _value.destinationAddress
                : destinationAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            originLat: null == originLat
                ? _value.originLat
                : originLat // ignore: cast_nullable_to_non_nullable
                      as double,
            originLng: null == originLng
                ? _value.originLng
                : originLng // ignore: cast_nullable_to_non_nullable
                      as double,
            destinationLat: null == destinationLat
                ? _value.destinationLat
                : destinationLat // ignore: cast_nullable_to_non_nullable
                      as double,
            destinationLng: null == destinationLng
                ? _value.destinationLng
                : destinationLng // ignore: cast_nullable_to_non_nullable
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
                      as int,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            allowPets: null == allowPets
                ? _value.allowPets
                : allowPets // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowSmoking: null == allowSmoking
                ? _value.allowSmoking
                : allowSmoking // ignore: cast_nullable_to_non_nullable
                      as bool,
            amenities: null == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
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
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'direction') String direction,
    String driverId,
    String? passengerId,
    @JsonKey(name: 'origin_address') String originAddress,
    @JsonKey(name: 'destination_address') String destinationAddress,
    @JsonKey(name: 'origin_lat') double originLat,
    @JsonKey(name: 'origin_lng') double originLng,
    @JsonKey(name: 'destination_lat') double destinationLat,
    @JsonKey(name: 'destination_lng') double destinationLng,
    @JsonKey(name: 'departure_time') DateTime departureTime,
    double distance,
    @JsonKey(name: 'estimated_duration') int estimatedDuration,
    @JsonKey(name: 'price_per_seat') double pricePerSeat,
    @JsonKey(name: 'total_seats') int totalSeats,
    @JsonKey(name: 'available_seats') int availableSeats,
    @JsonKey(name: 'passenger_ids') List<String> passengerIds,
    String status,
    String? description,
    bool allowPets,
    bool allowSmoking,
    List<String> amenities,
    Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? direction = null,
    Object? driverId = null,
    Object? passengerId = freezed,
    Object? originAddress = null,
    Object? destinationAddress = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destinationLat = null,
    Object? destinationLng = null,
    Object? departureTime = null,
    Object? distance = null,
    Object? estimatedDuration = null,
    Object? pricePerSeat = null,
    Object? totalSeats = null,
    Object? availableSeats = null,
    Object? passengerIds = null,
    Object? status = null,
    Object? description = freezed,
    Object? allowPets = null,
    Object? allowSmoking = null,
    Object? amenities = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: null == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String,
        passengerId: freezed == passengerId
            ? _value.passengerId
            : passengerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        originAddress: null == originAddress
            ? _value.originAddress
            : originAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationAddress: null == destinationAddress
            ? _value.destinationAddress
            : destinationAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        originLat: null == originLat
            ? _value.originLat
            : originLat // ignore: cast_nullable_to_non_nullable
                  as double,
        originLng: null == originLng
            ? _value.originLng
            : originLng // ignore: cast_nullable_to_non_nullable
                  as double,
        destinationLat: null == destinationLat
            ? _value.destinationLat
            : destinationLat // ignore: cast_nullable_to_non_nullable
                  as double,
        destinationLng: null == destinationLng
            ? _value.destinationLng
            : destinationLng // ignore: cast_nullable_to_non_nullable
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
                  as int,
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        allowPets: null == allowPets
            ? _value.allowPets
            : allowPets // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowSmoking: null == allowSmoking
            ? _value.allowSmoking
            : allowSmoking // ignore: cast_nullable_to_non_nullable
                  as bool,
        amenities: null == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
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
class _$TripImpl implements _Trip {
  const _$TripImpl({
    required this.id,
    @JsonKey(name: 'type') required this.type,
    @JsonKey(name: 'direction') required this.direction,
    required this.driverId,
    this.passengerId,
    @JsonKey(name: 'origin_address') required this.originAddress,
    @JsonKey(name: 'destination_address') required this.destinationAddress,
    @JsonKey(name: 'origin_lat') required this.originLat,
    @JsonKey(name: 'origin_lng') required this.originLng,
    @JsonKey(name: 'destination_lat') required this.destinationLat,
    @JsonKey(name: 'destination_lng') required this.destinationLng,
    @JsonKey(name: 'departure_time') required this.departureTime,
    required this.distance,
    @JsonKey(name: 'estimated_duration') required this.estimatedDuration,
    @JsonKey(name: 'price_per_seat') required this.pricePerSeat,
    @JsonKey(name: 'total_seats') required this.totalSeats,
    @JsonKey(name: 'available_seats') required this.availableSeats,
    @JsonKey(name: 'passenger_ids') final List<String> passengerIds = const [],
    this.status = 'pending',
    this.description,
    this.allowPets = false,
    this.allowSmoking = false,
    final List<String> amenities = const [],
    final Map<String, dynamic> metadata = const {},
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _passengerIds = passengerIds,
       _amenities = amenities,
       _metadata = metadata;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'type')
  final String type;
  // 'person' or 'package'
  @override
  @JsonKey(name: 'direction')
  final String direction;
  // 'offer' or 'request'
  @override
  final String driverId;
  @override
  final String? passengerId;
  @override
  @JsonKey(name: 'origin_address')
  final String originAddress;
  @override
  @JsonKey(name: 'destination_address')
  final String destinationAddress;
  @override
  @JsonKey(name: 'origin_lat')
  final double originLat;
  @override
  @JsonKey(name: 'origin_lng')
  final double originLng;
  @override
  @JsonKey(name: 'destination_lat')
  final double destinationLat;
  @override
  @JsonKey(name: 'destination_lng')
  final double destinationLng;
  @override
  @JsonKey(name: 'departure_time')
  final DateTime departureTime;
  @override
  final double distance;
  // km
  @override
  @JsonKey(name: 'estimated_duration')
  final int estimatedDuration;
  // minutes
  @override
  @JsonKey(name: 'price_per_seat')
  final double pricePerSeat;
  @override
  @JsonKey(name: 'total_seats')
  final int totalSeats;
  @override
  @JsonKey(name: 'available_seats')
  final int availableSeats;
  final List<String> _passengerIds;
  @override
  @JsonKey(name: 'passenger_ids')
  List<String> get passengerIds {
    if (_passengerIds is EqualUnmodifiableListView) return _passengerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengerIds);
  }

  @override
  @JsonKey()
  final String status;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool allowPets;
  @override
  @JsonKey()
  final bool allowSmoking;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Trip(id: $id, type: $type, direction: $direction, driverId: $driverId, passengerId: $passengerId, originAddress: $originAddress, destinationAddress: $destinationAddress, originLat: $originLat, originLng: $originLng, destinationLat: $destinationLat, destinationLng: $destinationLng, departureTime: $departureTime, distance: $distance, estimatedDuration: $estimatedDuration, pricePerSeat: $pricePerSeat, totalSeats: $totalSeats, availableSeats: $availableSeats, passengerIds: $passengerIds, status: $status, description: $description, allowPets: $allowPets, allowSmoking: $allowSmoking, amenities: $amenities, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.passengerId, passengerId) ||
                other.passengerId == passengerId) &&
            (identical(other.originAddress, originAddress) ||
                other.originAddress == originAddress) &&
            (identical(other.destinationAddress, destinationAddress) ||
                other.destinationAddress == destinationAddress) &&
            (identical(other.originLat, originLat) ||
                other.originLat == originLat) &&
            (identical(other.originLng, originLng) ||
                other.originLng == originLng) &&
            (identical(other.destinationLat, destinationLat) ||
                other.destinationLat == destinationLat) &&
            (identical(other.destinationLng, destinationLng) ||
                other.destinationLng == destinationLng) &&
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
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.allowPets, allowPets) ||
                other.allowPets == allowPets) &&
            (identical(other.allowSmoking, allowSmoking) ||
                other.allowSmoking == allowSmoking) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    type,
    direction,
    driverId,
    passengerId,
    originAddress,
    destinationAddress,
    originLat,
    originLng,
    destinationLat,
    destinationLng,
    departureTime,
    distance,
    estimatedDuration,
    pricePerSeat,
    totalSeats,
    availableSeats,
    const DeepCollectionEquality().hash(_passengerIds),
    status,
    description,
    allowPets,
    allowSmoking,
    const DeepCollectionEquality().hash(_amenities),
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(this);
  }
}

abstract class _Trip implements Trip {
  const factory _Trip({
    required final String id,
    @JsonKey(name: 'type') required final String type,
    @JsonKey(name: 'direction') required final String direction,
    required final String driverId,
    final String? passengerId,
    @JsonKey(name: 'origin_address') required final String originAddress,
    @JsonKey(name: 'destination_address')
    required final String destinationAddress,
    @JsonKey(name: 'origin_lat') required final double originLat,
    @JsonKey(name: 'origin_lng') required final double originLng,
    @JsonKey(name: 'destination_lat') required final double destinationLat,
    @JsonKey(name: 'destination_lng') required final double destinationLng,
    @JsonKey(name: 'departure_time') required final DateTime departureTime,
    required final double distance,
    @JsonKey(name: 'estimated_duration') required final int estimatedDuration,
    @JsonKey(name: 'price_per_seat') required final double pricePerSeat,
    @JsonKey(name: 'total_seats') required final int totalSeats,
    @JsonKey(name: 'available_seats') required final int availableSeats,
    @JsonKey(name: 'passenger_ids') final List<String> passengerIds,
    final String status,
    final String? description,
    final bool allowPets,
    final bool allowSmoking,
    final List<String> amenities,
    final Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'type')
  String get type; // 'person' or 'package'
  @override
  @JsonKey(name: 'direction')
  String get direction; // 'offer' or 'request'
  @override
  String get driverId;
  @override
  String? get passengerId;
  @override
  @JsonKey(name: 'origin_address')
  String get originAddress;
  @override
  @JsonKey(name: 'destination_address')
  String get destinationAddress;
  @override
  @JsonKey(name: 'origin_lat')
  double get originLat;
  @override
  @JsonKey(name: 'origin_lng')
  double get originLng;
  @override
  @JsonKey(name: 'destination_lat')
  double get destinationLat;
  @override
  @JsonKey(name: 'destination_lng')
  double get destinationLng;
  @override
  @JsonKey(name: 'departure_time')
  DateTime get departureTime;
  @override
  double get distance; // km
  @override
  @JsonKey(name: 'estimated_duration')
  int get estimatedDuration; // minutes
  @override
  @JsonKey(name: 'price_per_seat')
  double get pricePerSeat;
  @override
  @JsonKey(name: 'total_seats')
  int get totalSeats;
  @override
  @JsonKey(name: 'available_seats')
  int get availableSeats;
  @override
  @JsonKey(name: 'passenger_ids')
  List<String> get passengerIds;
  @override
  String get status;
  @override
  String? get description;
  @override
  bool get allowPets;
  @override
  bool get allowSmoking;
  @override
  List<String> get amenities;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
