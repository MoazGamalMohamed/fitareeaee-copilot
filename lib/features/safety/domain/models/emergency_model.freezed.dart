// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmergencyAlert _$EmergencyAlertFromJson(Map<String, dynamic> json) {
  return _EmergencyAlert.fromJson(json);
}

/// @nodoc
mixin _$EmergencyAlert {
  String get id => throw _privateConstructorUsedError;
  String get oderId => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  EmergencyType get type => throw _privateConstructorUsedError;
  EmergencyStatus get status => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get emergencyContacts => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  String? get resolutionNotes => throw _privateConstructorUsedError;

  /// Serializes this EmergencyAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyAlertCopyWith<EmergencyAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyAlertCopyWith<$Res> {
  factory $EmergencyAlertCopyWith(
    EmergencyAlert value,
    $Res Function(EmergencyAlert) then,
  ) = _$EmergencyAlertCopyWithImpl<$Res, EmergencyAlert>;
  @useResult
  $Res call({
    String id,
    String oderId,
    String? tripId,
    EmergencyType type,
    EmergencyStatus status,
    double latitude,
    double longitude,
    String? description,
    List<String>? emergencyContacts,
    DateTime createdAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
  });
}

/// @nodoc
class _$EmergencyAlertCopyWithImpl<$Res, $Val extends EmergencyAlert>
    implements $EmergencyAlertCopyWith<$Res> {
  _$EmergencyAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? oderId = null,
    Object? tripId = freezed,
    Object? type = null,
    Object? status = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? emergencyContacts = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
    Object? resolutionNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            oderId: null == oderId
                ? _value.oderId
                : oderId // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: freezed == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as EmergencyType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EmergencyStatus,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyContacts: freezed == emergencyContacts
                ? _value.emergencyContacts
                : emergencyContacts // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            resolvedBy: freezed == resolvedBy
                ? _value.resolvedBy
                : resolvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolutionNotes: freezed == resolutionNotes
                ? _value.resolutionNotes
                : resolutionNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmergencyAlertImplCopyWith<$Res>
    implements $EmergencyAlertCopyWith<$Res> {
  factory _$$EmergencyAlertImplCopyWith(
    _$EmergencyAlertImpl value,
    $Res Function(_$EmergencyAlertImpl) then,
  ) = __$$EmergencyAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String oderId,
    String? tripId,
    EmergencyType type,
    EmergencyStatus status,
    double latitude,
    double longitude,
    String? description,
    List<String>? emergencyContacts,
    DateTime createdAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
  });
}

/// @nodoc
class __$$EmergencyAlertImplCopyWithImpl<$Res>
    extends _$EmergencyAlertCopyWithImpl<$Res, _$EmergencyAlertImpl>
    implements _$$EmergencyAlertImplCopyWith<$Res> {
  __$$EmergencyAlertImplCopyWithImpl(
    _$EmergencyAlertImpl _value,
    $Res Function(_$EmergencyAlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmergencyAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? oderId = null,
    Object? tripId = freezed,
    Object? type = null,
    Object? status = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? emergencyContacts = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? resolvedBy = freezed,
    Object? resolutionNotes = freezed,
  }) {
    return _then(
      _$EmergencyAlertImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        oderId: null == oderId
            ? _value.oderId
            : oderId // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: freezed == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as EmergencyType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EmergencyStatus,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyContacts: freezed == emergencyContacts
            ? _value._emergencyContacts
            : emergencyContacts // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        resolvedBy: freezed == resolvedBy
            ? _value.resolvedBy
            : resolvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolutionNotes: freezed == resolutionNotes
            ? _value.resolutionNotes
            : resolutionNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyAlertImpl extends _EmergencyAlert {
  const _$EmergencyAlertImpl({
    required this.id,
    required this.oderId,
    this.tripId,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.description,
    final List<String>? emergencyContacts,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
  }) : _emergencyContacts = emergencyContacts,
       super._();

  factory _$EmergencyAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyAlertImplFromJson(json);

  @override
  final String id;
  @override
  final String oderId;
  @override
  final String? tripId;
  @override
  final EmergencyType type;
  @override
  final EmergencyStatus status;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? description;
  final List<String>? _emergencyContacts;
  @override
  List<String>? get emergencyContacts {
    final value = _emergencyContacts;
    if (value == null) return null;
    if (_emergencyContacts is EqualUnmodifiableListView)
      return _emergencyContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? resolvedBy;
  @override
  final String? resolutionNotes;

  @override
  String toString() {
    return 'EmergencyAlert(id: $id, oderId: $oderId, tripId: $tripId, type: $type, status: $status, latitude: $latitude, longitude: $longitude, description: $description, emergencyContacts: $emergencyContacts, createdAt: $createdAt, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy, resolutionNotes: $resolutionNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.oderId, oderId) || other.oderId == oderId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._emergencyContacts,
              _emergencyContacts,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolutionNotes, resolutionNotes) ||
                other.resolutionNotes == resolutionNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    oderId,
    tripId,
    type,
    status,
    latitude,
    longitude,
    description,
    const DeepCollectionEquality().hash(_emergencyContacts),
    createdAt,
    resolvedAt,
    resolvedBy,
    resolutionNotes,
  );

  /// Create a copy of EmergencyAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyAlertImplCopyWith<_$EmergencyAlertImpl> get copyWith =>
      __$$EmergencyAlertImplCopyWithImpl<_$EmergencyAlertImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyAlertImplToJson(this);
  }
}

abstract class _EmergencyAlert extends EmergencyAlert {
  const factory _EmergencyAlert({
    required final String id,
    required final String oderId,
    final String? tripId,
    required final EmergencyType type,
    required final EmergencyStatus status,
    required final double latitude,
    required final double longitude,
    final String? description,
    final List<String>? emergencyContacts,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
    final String? resolvedBy,
    final String? resolutionNotes,
  }) = _$EmergencyAlertImpl;
  const _EmergencyAlert._() : super._();

  factory _EmergencyAlert.fromJson(Map<String, dynamic> json) =
      _$EmergencyAlertImpl.fromJson;

  @override
  String get id;
  @override
  String get oderId;
  @override
  String? get tripId;
  @override
  EmergencyType get type;
  @override
  EmergencyStatus get status;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get description;
  @override
  List<String>? get emergencyContacts;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;
  @override
  String? get resolvedBy;
  @override
  String? get resolutionNotes;

  /// Create a copy of EmergencyAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyAlertImplCopyWith<_$EmergencyAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmergencyContact _$EmergencyContactFromJson(Map<String, dynamic> json) {
  return _EmergencyContact.fromJson(json);
}

/// @nodoc
mixin _$EmergencyContact {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get relationship => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EmergencyContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyContactCopyWith<EmergencyContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyContactCopyWith<$Res> {
  factory $EmergencyContactCopyWith(
    EmergencyContact value,
    $Res Function(EmergencyContact) then,
  ) = _$EmergencyContactCopyWithImpl<$Res, EmergencyContact>;
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String phone,
    String? relationship,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$EmergencyContactCopyWithImpl<$Res, $Val extends EmergencyContact>
    implements $EmergencyContactCopyWith<$Res> {
  _$EmergencyContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? relationship = freezed,
    Object? isActive = null,
    Object? createdAt = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            relationship: freezed == relationship
                ? _value.relationship
                : relationship // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmergencyContactImplCopyWith<$Res>
    implements $EmergencyContactCopyWith<$Res> {
  factory _$$EmergencyContactImplCopyWith(
    _$EmergencyContactImpl value,
    $Res Function(_$EmergencyContactImpl) then,
  ) = __$$EmergencyContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String phone,
    String? relationship,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$EmergencyContactImplCopyWithImpl<$Res>
    extends _$EmergencyContactCopyWithImpl<$Res, _$EmergencyContactImpl>
    implements _$$EmergencyContactImplCopyWith<$Res> {
  __$$EmergencyContactImplCopyWithImpl(
    _$EmergencyContactImpl _value,
    $Res Function(_$EmergencyContactImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmergencyContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? relationship = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$EmergencyContactImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        relationship: freezed == relationship
            ? _value.relationship
            : relationship // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyContactImpl implements _EmergencyContact {
  const _$EmergencyContactImpl({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.relationship,
    this.isActive = true,
    required this.createdAt,
  });

  factory _$EmergencyContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyContactImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? relationship;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'EmergencyContact(id: $id, userId: $userId, name: $name, phone: $phone, relationship: $relationship, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    phone,
    relationship,
    isActive,
    createdAt,
  );

  /// Create a copy of EmergencyContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyContactImplCopyWith<_$EmergencyContactImpl> get copyWith =>
      __$$EmergencyContactImplCopyWithImpl<_$EmergencyContactImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyContactImplToJson(this);
  }
}

abstract class _EmergencyContact implements EmergencyContact {
  const factory _EmergencyContact({
    required final String id,
    required final String userId,
    required final String name,
    required final String phone,
    final String? relationship,
    final bool isActive,
    required final DateTime createdAt,
  }) = _$EmergencyContactImpl;

  factory _EmergencyContact.fromJson(Map<String, dynamic> json) =
      _$EmergencyContactImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String? get relationship;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of EmergencyContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyContactImplCopyWith<_$EmergencyContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SafetySettings _$SafetySettingsFromJson(Map<String, dynamic> json) {
  return _SafetySettings.fromJson(json);
}

/// @nodoc
mixin _$SafetySettings {
  bool get sosEnabled => throw _privateConstructorUsedError;
  bool get shareLocationOnSOS => throw _privateConstructorUsedError;
  bool get notifyEmergencyContacts => throw _privateConstructorUsedError;
  bool get autoCallEmergency => throw _privateConstructorUsedError;
  String? get emergencyNumber => throw _privateConstructorUsedError;
  List<EmergencyContact> get emergencyContacts =>
      throw _privateConstructorUsedError;

  /// Serializes this SafetySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SafetySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SafetySettingsCopyWith<SafetySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SafetySettingsCopyWith<$Res> {
  factory $SafetySettingsCopyWith(
    SafetySettings value,
    $Res Function(SafetySettings) then,
  ) = _$SafetySettingsCopyWithImpl<$Res, SafetySettings>;
  @useResult
  $Res call({
    bool sosEnabled,
    bool shareLocationOnSOS,
    bool notifyEmergencyContacts,
    bool autoCallEmergency,
    String? emergencyNumber,
    List<EmergencyContact> emergencyContacts,
  });
}

/// @nodoc
class _$SafetySettingsCopyWithImpl<$Res, $Val extends SafetySettings>
    implements $SafetySettingsCopyWith<$Res> {
  _$SafetySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SafetySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sosEnabled = null,
    Object? shareLocationOnSOS = null,
    Object? notifyEmergencyContacts = null,
    Object? autoCallEmergency = null,
    Object? emergencyNumber = freezed,
    Object? emergencyContacts = null,
  }) {
    return _then(
      _value.copyWith(
            sosEnabled: null == sosEnabled
                ? _value.sosEnabled
                : sosEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            shareLocationOnSOS: null == shareLocationOnSOS
                ? _value.shareLocationOnSOS
                : shareLocationOnSOS // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifyEmergencyContacts: null == notifyEmergencyContacts
                ? _value.notifyEmergencyContacts
                : notifyEmergencyContacts // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoCallEmergency: null == autoCallEmergency
                ? _value.autoCallEmergency
                : autoCallEmergency // ignore: cast_nullable_to_non_nullable
                      as bool,
            emergencyNumber: freezed == emergencyNumber
                ? _value.emergencyNumber
                : emergencyNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyContacts: null == emergencyContacts
                ? _value.emergencyContacts
                : emergencyContacts // ignore: cast_nullable_to_non_nullable
                      as List<EmergencyContact>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SafetySettingsImplCopyWith<$Res>
    implements $SafetySettingsCopyWith<$Res> {
  factory _$$SafetySettingsImplCopyWith(
    _$SafetySettingsImpl value,
    $Res Function(_$SafetySettingsImpl) then,
  ) = __$$SafetySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool sosEnabled,
    bool shareLocationOnSOS,
    bool notifyEmergencyContacts,
    bool autoCallEmergency,
    String? emergencyNumber,
    List<EmergencyContact> emergencyContacts,
  });
}

/// @nodoc
class __$$SafetySettingsImplCopyWithImpl<$Res>
    extends _$SafetySettingsCopyWithImpl<$Res, _$SafetySettingsImpl>
    implements _$$SafetySettingsImplCopyWith<$Res> {
  __$$SafetySettingsImplCopyWithImpl(
    _$SafetySettingsImpl _value,
    $Res Function(_$SafetySettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SafetySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sosEnabled = null,
    Object? shareLocationOnSOS = null,
    Object? notifyEmergencyContacts = null,
    Object? autoCallEmergency = null,
    Object? emergencyNumber = freezed,
    Object? emergencyContacts = null,
  }) {
    return _then(
      _$SafetySettingsImpl(
        sosEnabled: null == sosEnabled
            ? _value.sosEnabled
            : sosEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        shareLocationOnSOS: null == shareLocationOnSOS
            ? _value.shareLocationOnSOS
            : shareLocationOnSOS // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifyEmergencyContacts: null == notifyEmergencyContacts
            ? _value.notifyEmergencyContacts
            : notifyEmergencyContacts // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoCallEmergency: null == autoCallEmergency
            ? _value.autoCallEmergency
            : autoCallEmergency // ignore: cast_nullable_to_non_nullable
                  as bool,
        emergencyNumber: freezed == emergencyNumber
            ? _value.emergencyNumber
            : emergencyNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyContacts: null == emergencyContacts
            ? _value._emergencyContacts
            : emergencyContacts // ignore: cast_nullable_to_non_nullable
                  as List<EmergencyContact>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SafetySettingsImpl implements _SafetySettings {
  const _$SafetySettingsImpl({
    this.sosEnabled = true,
    this.shareLocationOnSOS = true,
    this.notifyEmergencyContacts = true,
    this.autoCallEmergency = true,
    this.emergencyNumber,
    final List<EmergencyContact> emergencyContacts = const [],
  }) : _emergencyContacts = emergencyContacts;

  factory _$SafetySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SafetySettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool sosEnabled;
  @override
  @JsonKey()
  final bool shareLocationOnSOS;
  @override
  @JsonKey()
  final bool notifyEmergencyContacts;
  @override
  @JsonKey()
  final bool autoCallEmergency;
  @override
  final String? emergencyNumber;
  final List<EmergencyContact> _emergencyContacts;
  @override
  @JsonKey()
  List<EmergencyContact> get emergencyContacts {
    if (_emergencyContacts is EqualUnmodifiableListView)
      return _emergencyContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emergencyContacts);
  }

  @override
  String toString() {
    return 'SafetySettings(sosEnabled: $sosEnabled, shareLocationOnSOS: $shareLocationOnSOS, notifyEmergencyContacts: $notifyEmergencyContacts, autoCallEmergency: $autoCallEmergency, emergencyNumber: $emergencyNumber, emergencyContacts: $emergencyContacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafetySettingsImpl &&
            (identical(other.sosEnabled, sosEnabled) ||
                other.sosEnabled == sosEnabled) &&
            (identical(other.shareLocationOnSOS, shareLocationOnSOS) ||
                other.shareLocationOnSOS == shareLocationOnSOS) &&
            (identical(
                  other.notifyEmergencyContacts,
                  notifyEmergencyContacts,
                ) ||
                other.notifyEmergencyContacts == notifyEmergencyContacts) &&
            (identical(other.autoCallEmergency, autoCallEmergency) ||
                other.autoCallEmergency == autoCallEmergency) &&
            (identical(other.emergencyNumber, emergencyNumber) ||
                other.emergencyNumber == emergencyNumber) &&
            const DeepCollectionEquality().equals(
              other._emergencyContacts,
              _emergencyContacts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sosEnabled,
    shareLocationOnSOS,
    notifyEmergencyContacts,
    autoCallEmergency,
    emergencyNumber,
    const DeepCollectionEquality().hash(_emergencyContacts),
  );

  /// Create a copy of SafetySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SafetySettingsImplCopyWith<_$SafetySettingsImpl> get copyWith =>
      __$$SafetySettingsImplCopyWithImpl<_$SafetySettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SafetySettingsImplToJson(this);
  }
}

abstract class _SafetySettings implements SafetySettings {
  const factory _SafetySettings({
    final bool sosEnabled,
    final bool shareLocationOnSOS,
    final bool notifyEmergencyContacts,
    final bool autoCallEmergency,
    final String? emergencyNumber,
    final List<EmergencyContact> emergencyContacts,
  }) = _$SafetySettingsImpl;

  factory _SafetySettings.fromJson(Map<String, dynamic> json) =
      _$SafetySettingsImpl.fromJson;

  @override
  bool get sosEnabled;
  @override
  bool get shareLocationOnSOS;
  @override
  bool get notifyEmergencyContacts;
  @override
  bool get autoCallEmergency;
  @override
  String? get emergencyNumber;
  @override
  List<EmergencyContact> get emergencyContacts;

  /// Create a copy of SafetySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SafetySettingsImplCopyWith<_$SafetySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
