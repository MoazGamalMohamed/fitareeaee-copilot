// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserProfileModel {
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalRatings => throw _privateConstructorUsedError;
  int get totalTrips => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isPhoneVerified => throw _privateConstructorUsedError;
  bool get isProfileComplete => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
    UserProfileModel value,
    $Res Function(UserProfileModel) then,
  ) = _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call({
    String userId,
    String email,
    String name,
    String? phone,
    String? photoUrl,
    String? bio,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    List<String> roles,
    double rating,
    int totalRatings,
    int totalTrips,
    bool isEmailVerified,
    bool isPhoneVerified,
    bool isProfileComplete,
    Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? roles = null,
    Object? rating = null,
    Object? totalRatings = null,
    Object? totalTrips = null,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? isProfileComplete = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRatings: null == totalRatings
                ? _value.totalRatings
                : totalRatings // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTrips: null == totalTrips
                ? _value.totalTrips
                : totalTrips // ignore: cast_nullable_to_non_nullable
                      as int,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPhoneVerified: null == isPhoneVerified
                ? _value.isPhoneVerified
                : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isProfileComplete: null == isProfileComplete
                ? _value.isProfileComplete
                : isProfileComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(
    _$UserProfileModelImpl value,
    $Res Function(_$UserProfileModelImpl) then,
  ) = __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String email,
    String name,
    String? phone,
    String? photoUrl,
    String? bio,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    List<String> roles,
    double rating,
    int totalRatings,
    int totalTrips,
    bool isEmailVerified,
    bool isPhoneVerified,
    bool isProfileComplete,
    Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(
    _$UserProfileModelImpl _value,
    $Res Function(_$UserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? roles = null,
    Object? rating = null,
    Object? totalRatings = null,
    Object? totalTrips = null,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? isProfileComplete = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UserProfileModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRatings: null == totalRatings
            ? _value.totalRatings
            : totalRatings // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTrips: null == totalTrips
            ? _value.totalTrips
            : totalTrips // ignore: cast_nullable_to_non_nullable
                  as int,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPhoneVerified: null == isPhoneVerified
            ? _value.isPhoneVerified
            : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isProfileComplete: null == isProfileComplete
            ? _value.isProfileComplete
            : isProfileComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
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

class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl({
    required this.userId,
    required this.email,
    required this.name,
    this.phone,
    this.photoUrl,
    this.bio,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    final List<String> roles = const [],
    this.rating = 0.0,
    this.totalRatings = 0,
    this.totalTrips = 0,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isProfileComplete = false,
    final Map<String, dynamic> metadata = const {},
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _roles = roles,
       _metadata = metadata;

  @override
  final String userId;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? photoUrl;
  @override
  final String? bio;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalRatings;
  @override
  @JsonKey()
  final int totalTrips;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  @JsonKey()
  final bool isPhoneVerified;
  @override
  @JsonKey()
  final bool isProfileComplete;
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
    return 'UserProfileModel(userId: $userId, email: $email, name: $name, phone: $phone, photoUrl: $photoUrl, bio: $bio, address: $address, city: $city, country: $country, latitude: $latitude, longitude: $longitude, roles: $roles, rating: $rating, totalRatings: $totalRatings, totalTrips: $totalTrips, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, isProfileComplete: $isProfileComplete, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.totalTrips, totalTrips) ||
                other.totalTrips == totalTrips) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isPhoneVerified, isPhoneVerified) ||
                other.isPhoneVerified == isPhoneVerified) &&
            (identical(other.isProfileComplete, isProfileComplete) ||
                other.isProfileComplete == isProfileComplete) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    userId,
    email,
    name,
    phone,
    photoUrl,
    bio,
    address,
    city,
    country,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_roles),
    rating,
    totalRatings,
    totalTrips,
    isEmailVerified,
    isPhoneVerified,
    isProfileComplete,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
        this,
        _$identity,
      );
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel({
    required final String userId,
    required final String email,
    required final String name,
    final String? phone,
    final String? photoUrl,
    final String? bio,
    final String? address,
    final String? city,
    final String? country,
    final double? latitude,
    final double? longitude,
    final List<String> roles,
    final double rating,
    final int totalRatings,
    final int totalTrips,
    final bool isEmailVerified,
    final bool isPhoneVerified,
    final bool isProfileComplete,
    final Map<String, dynamic> metadata,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$UserProfileModelImpl;

  @override
  String get userId;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get photoUrl;
  @override
  String? get bio;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get country;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<String> get roles;
  @override
  double get rating;
  @override
  int get totalRatings;
  @override
  int get totalTrips;
  @override
  bool get isEmailVerified;
  @override
  bool get isPhoneVerified;
  @override
  bool get isProfileComplete;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
