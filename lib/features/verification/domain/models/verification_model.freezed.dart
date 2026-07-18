// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerificationModel _$VerificationModelFromJson(Map<String, dynamic> json) {
  return _VerificationModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationModel {
  String get id => throw _privateConstructorUsedError;
  String get oderId => throw _privateConstructorUsedError;
  VerificationType get type => throw _privateConstructorUsedError;
  VerificationStatus get status => throw _privateConstructorUsedError;
  String? get documentUrl => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VerificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationModelCopyWith<VerificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationModelCopyWith<$Res> {
  factory $VerificationModelCopyWith(
    VerificationModel value,
    $Res Function(VerificationModel) then,
  ) = _$VerificationModelCopyWithImpl<$Res, VerificationModel>;
  @useResult
  $Res call({
    String id,
    String oderId,
    VerificationType type,
    VerificationStatus status,
    String? documentUrl,
    String? rejectionReason,
    DateTime? expiryDate,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$VerificationModelCopyWithImpl<$Res, $Val extends VerificationModel>
    implements $VerificationModelCopyWith<$Res> {
  _$VerificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? oderId = null,
    Object? type = null,
    Object? status = null,
    Object? documentUrl = freezed,
    Object? rejectionReason = freezed,
    Object? expiryDate = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as VerificationType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VerificationStatus,
            documentUrl: freezed == documentUrl
                ? _value.documentUrl
                : documentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            verifiedBy: freezed == verifiedBy
                ? _value.verifiedBy
                : verifiedBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VerificationModelImplCopyWith<$Res>
    implements $VerificationModelCopyWith<$Res> {
  factory _$$VerificationModelImplCopyWith(
    _$VerificationModelImpl value,
    $Res Function(_$VerificationModelImpl) then,
  ) = __$$VerificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String oderId,
    VerificationType type,
    VerificationStatus status,
    String? documentUrl,
    String? rejectionReason,
    DateTime? expiryDate,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$VerificationModelImplCopyWithImpl<$Res>
    extends _$VerificationModelCopyWithImpl<$Res, _$VerificationModelImpl>
    implements _$$VerificationModelImplCopyWith<$Res> {
  __$$VerificationModelImplCopyWithImpl(
    _$VerificationModelImpl _value,
    $Res Function(_$VerificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? oderId = null,
    Object? type = null,
    Object? status = null,
    Object? documentUrl = freezed,
    Object? rejectionReason = freezed,
    Object? expiryDate = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$VerificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        oderId: null == oderId
            ? _value.oderId
            : oderId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as VerificationType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VerificationStatus,
        documentUrl: freezed == documentUrl
            ? _value.documentUrl
            : documentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        verifiedBy: freezed == verifiedBy
            ? _value.verifiedBy
            : verifiedBy // ignore: cast_nullable_to_non_nullable
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
class _$VerificationModelImpl implements _VerificationModel {
  const _$VerificationModelImpl({
    required this.id,
    required this.oderId,
    required this.type,
    required this.status,
    this.documentUrl,
    this.rejectionReason,
    this.expiryDate,
    this.verifiedAt,
    this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$VerificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String oderId;
  @override
  final VerificationType type;
  @override
  final VerificationStatus status;
  @override
  final String? documentUrl;
  @override
  final String? rejectionReason;
  @override
  final DateTime? expiryDate;
  @override
  final DateTime? verifiedAt;
  @override
  final String? verifiedBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'VerificationModel(id: $id, oderId: $oderId, type: $type, status: $status, documentUrl: $documentUrl, rejectionReason: $rejectionReason, expiryDate: $expiryDate, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.oderId, oderId) || other.oderId == oderId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
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
    oderId,
    type,
    status,
    documentUrl,
    rejectionReason,
    expiryDate,
    verifiedAt,
    verifiedBy,
    createdAt,
    updatedAt,
  );

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      __$$VerificationModelImplCopyWithImpl<_$VerificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationModelImplToJson(this);
  }
}

abstract class _VerificationModel implements VerificationModel {
  const factory _VerificationModel({
    required final String id,
    required final String oderId,
    required final VerificationType type,
    required final VerificationStatus status,
    final String? documentUrl,
    final String? rejectionReason,
    final DateTime? expiryDate,
    final DateTime? verifiedAt,
    final String? verifiedBy,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$VerificationModelImpl;

  factory _VerificationModel.fromJson(Map<String, dynamic> json) =
      _$VerificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get oderId;
  @override
  VerificationType get type;
  @override
  VerificationStatus get status;
  @override
  String? get documentUrl;
  @override
  String? get rejectionReason;
  @override
  DateTime? get expiryDate;
  @override
  DateTime? get verifiedAt;
  @override
  String? get verifiedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserVerification _$UserVerificationFromJson(Map<String, dynamic> json) {
  return _UserVerification.fromJson(json);
}

/// @nodoc
mixin _$UserVerification {
  String get userId => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  bool get phoneVerified => throw _privateConstructorUsedError;
  bool get identityVerified => throw _privateConstructorUsedError;
  bool get driverLicenseVerified => throw _privateConstructorUsedError;
  bool get vehicleVerified => throw _privateConstructorUsedError;
  bool get selfieWithIdVerified => throw _privateConstructorUsedError;
  String? get identityDocumentUrl => throw _privateConstructorUsedError;
  String? get driverLicenseUrl => throw _privateConstructorUsedError;
  String? get vehicleRegistrationUrl => throw _privateConstructorUsedError;
  String? get selfieWithIdUrl => throw _privateConstructorUsedError;
  String? get vehiclePlateNumber => throw _privateConstructorUsedError;
  String? get vehicleModel => throw _privateConstructorUsedError;
  String? get vehicleColor => throw _privateConstructorUsedError;
  DateTime? get identityVerifiedAt => throw _privateConstructorUsedError;
  DateTime? get driverLicenseVerifiedAt => throw _privateConstructorUsedError;
  DateTime? get vehicleVerifiedAt => throw _privateConstructorUsedError;
  DateTime? get selfieWithIdVerifiedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserVerificationCopyWith<UserVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserVerificationCopyWith<$Res> {
  factory $UserVerificationCopyWith(
    UserVerification value,
    $Res Function(UserVerification) then,
  ) = _$UserVerificationCopyWithImpl<$Res, UserVerification>;
  @useResult
  $Res call({
    String userId,
    bool emailVerified,
    bool phoneVerified,
    bool identityVerified,
    bool driverLicenseVerified,
    bool vehicleVerified,
    bool selfieWithIdVerified,
    String? identityDocumentUrl,
    String? driverLicenseUrl,
    String? vehicleRegistrationUrl,
    String? selfieWithIdUrl,
    String? vehiclePlateNumber,
    String? vehicleModel,
    String? vehicleColor,
    DateTime? identityVerifiedAt,
    DateTime? driverLicenseVerifiedAt,
    DateTime? vehicleVerifiedAt,
    DateTime? selfieWithIdVerifiedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$UserVerificationCopyWithImpl<$Res, $Val extends UserVerification>
    implements $UserVerificationCopyWith<$Res> {
  _$UserVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? identityVerified = null,
    Object? driverLicenseVerified = null,
    Object? vehicleVerified = null,
    Object? selfieWithIdVerified = null,
    Object? identityDocumentUrl = freezed,
    Object? driverLicenseUrl = freezed,
    Object? vehicleRegistrationUrl = freezed,
    Object? selfieWithIdUrl = freezed,
    Object? vehiclePlateNumber = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleColor = freezed,
    Object? identityVerifiedAt = freezed,
    Object? driverLicenseVerifiedAt = freezed,
    Object? vehicleVerifiedAt = freezed,
    Object? selfieWithIdVerifiedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            emailVerified: null == emailVerified
                ? _value.emailVerified
                : emailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            phoneVerified: null == phoneVerified
                ? _value.phoneVerified
                : phoneVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            identityVerified: null == identityVerified
                ? _value.identityVerified
                : identityVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            driverLicenseVerified: null == driverLicenseVerified
                ? _value.driverLicenseVerified
                : driverLicenseVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            vehicleVerified: null == vehicleVerified
                ? _value.vehicleVerified
                : vehicleVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            selfieWithIdVerified: null == selfieWithIdVerified
                ? _value.selfieWithIdVerified
                : selfieWithIdVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            identityDocumentUrl: freezed == identityDocumentUrl
                ? _value.identityDocumentUrl
                : identityDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverLicenseUrl: freezed == driverLicenseUrl
                ? _value.driverLicenseUrl
                : driverLicenseUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleRegistrationUrl: freezed == vehicleRegistrationUrl
                ? _value.vehicleRegistrationUrl
                : vehicleRegistrationUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            selfieWithIdUrl: freezed == selfieWithIdUrl
                ? _value.selfieWithIdUrl
                : selfieWithIdUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehiclePlateNumber: freezed == vehiclePlateNumber
                ? _value.vehiclePlateNumber
                : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleModel: freezed == vehicleModel
                ? _value.vehicleModel
                : vehicleModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleColor: freezed == vehicleColor
                ? _value.vehicleColor
                : vehicleColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            identityVerifiedAt: freezed == identityVerifiedAt
                ? _value.identityVerifiedAt
                : identityVerifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            driverLicenseVerifiedAt: freezed == driverLicenseVerifiedAt
                ? _value.driverLicenseVerifiedAt
                : driverLicenseVerifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            vehicleVerifiedAt: freezed == vehicleVerifiedAt
                ? _value.vehicleVerifiedAt
                : vehicleVerifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selfieWithIdVerifiedAt: freezed == selfieWithIdVerifiedAt
                ? _value.selfieWithIdVerifiedAt
                : selfieWithIdVerifiedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserVerificationImplCopyWith<$Res>
    implements $UserVerificationCopyWith<$Res> {
  factory _$$UserVerificationImplCopyWith(
    _$UserVerificationImpl value,
    $Res Function(_$UserVerificationImpl) then,
  ) = __$$UserVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    bool emailVerified,
    bool phoneVerified,
    bool identityVerified,
    bool driverLicenseVerified,
    bool vehicleVerified,
    bool selfieWithIdVerified,
    String? identityDocumentUrl,
    String? driverLicenseUrl,
    String? vehicleRegistrationUrl,
    String? selfieWithIdUrl,
    String? vehiclePlateNumber,
    String? vehicleModel,
    String? vehicleColor,
    DateTime? identityVerifiedAt,
    DateTime? driverLicenseVerifiedAt,
    DateTime? vehicleVerifiedAt,
    DateTime? selfieWithIdVerifiedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$UserVerificationImplCopyWithImpl<$Res>
    extends _$UserVerificationCopyWithImpl<$Res, _$UserVerificationImpl>
    implements _$$UserVerificationImplCopyWith<$Res> {
  __$$UserVerificationImplCopyWithImpl(
    _$UserVerificationImpl _value,
    $Res Function(_$UserVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? identityVerified = null,
    Object? driverLicenseVerified = null,
    Object? vehicleVerified = null,
    Object? selfieWithIdVerified = null,
    Object? identityDocumentUrl = freezed,
    Object? driverLicenseUrl = freezed,
    Object? vehicleRegistrationUrl = freezed,
    Object? selfieWithIdUrl = freezed,
    Object? vehiclePlateNumber = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleColor = freezed,
    Object? identityVerifiedAt = freezed,
    Object? driverLicenseVerifiedAt = freezed,
    Object? vehicleVerifiedAt = freezed,
    Object? selfieWithIdVerifiedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UserVerificationImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        emailVerified: null == emailVerified
            ? _value.emailVerified
            : emailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        phoneVerified: null == phoneVerified
            ? _value.phoneVerified
            : phoneVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        identityVerified: null == identityVerified
            ? _value.identityVerified
            : identityVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        driverLicenseVerified: null == driverLicenseVerified
            ? _value.driverLicenseVerified
            : driverLicenseVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        vehicleVerified: null == vehicleVerified
            ? _value.vehicleVerified
            : vehicleVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        selfieWithIdVerified: null == selfieWithIdVerified
            ? _value.selfieWithIdVerified
            : selfieWithIdVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        identityDocumentUrl: freezed == identityDocumentUrl
            ? _value.identityDocumentUrl
            : identityDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverLicenseUrl: freezed == driverLicenseUrl
            ? _value.driverLicenseUrl
            : driverLicenseUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleRegistrationUrl: freezed == vehicleRegistrationUrl
            ? _value.vehicleRegistrationUrl
            : vehicleRegistrationUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        selfieWithIdUrl: freezed == selfieWithIdUrl
            ? _value.selfieWithIdUrl
            : selfieWithIdUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehiclePlateNumber: freezed == vehiclePlateNumber
            ? _value.vehiclePlateNumber
            : vehiclePlateNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleModel: freezed == vehicleModel
            ? _value.vehicleModel
            : vehicleModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleColor: freezed == vehicleColor
            ? _value.vehicleColor
            : vehicleColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        identityVerifiedAt: freezed == identityVerifiedAt
            ? _value.identityVerifiedAt
            : identityVerifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        driverLicenseVerifiedAt: freezed == driverLicenseVerifiedAt
            ? _value.driverLicenseVerifiedAt
            : driverLicenseVerifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        vehicleVerifiedAt: freezed == vehicleVerifiedAt
            ? _value.vehicleVerifiedAt
            : vehicleVerifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selfieWithIdVerifiedAt: freezed == selfieWithIdVerifiedAt
            ? _value.selfieWithIdVerifiedAt
            : selfieWithIdVerifiedAt // ignore: cast_nullable_to_non_nullable
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
class _$UserVerificationImpl extends _UserVerification {
  const _$UserVerificationImpl({
    required this.userId,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.identityVerified = false,
    this.driverLicenseVerified = false,
    this.vehicleVerified = false,
    this.selfieWithIdVerified = false,
    this.identityDocumentUrl,
    this.driverLicenseUrl,
    this.vehicleRegistrationUrl,
    this.selfieWithIdUrl,
    this.vehiclePlateNumber,
    this.vehicleModel,
    this.vehicleColor,
    this.identityVerifiedAt,
    this.driverLicenseVerifiedAt,
    this.vehicleVerifiedAt,
    this.selfieWithIdVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$UserVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserVerificationImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final bool phoneVerified;
  @override
  @JsonKey()
  final bool identityVerified;
  @override
  @JsonKey()
  final bool driverLicenseVerified;
  @override
  @JsonKey()
  final bool vehicleVerified;
  @override
  @JsonKey()
  final bool selfieWithIdVerified;
  @override
  final String? identityDocumentUrl;
  @override
  final String? driverLicenseUrl;
  @override
  final String? vehicleRegistrationUrl;
  @override
  final String? selfieWithIdUrl;
  @override
  final String? vehiclePlateNumber;
  @override
  final String? vehicleModel;
  @override
  final String? vehicleColor;
  @override
  final DateTime? identityVerifiedAt;
  @override
  final DateTime? driverLicenseVerifiedAt;
  @override
  final DateTime? vehicleVerifiedAt;
  @override
  final DateTime? selfieWithIdVerifiedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserVerification(userId: $userId, emailVerified: $emailVerified, phoneVerified: $phoneVerified, identityVerified: $identityVerified, driverLicenseVerified: $driverLicenseVerified, vehicleVerified: $vehicleVerified, selfieWithIdVerified: $selfieWithIdVerified, identityDocumentUrl: $identityDocumentUrl, driverLicenseUrl: $driverLicenseUrl, vehicleRegistrationUrl: $vehicleRegistrationUrl, selfieWithIdUrl: $selfieWithIdUrl, vehiclePlateNumber: $vehiclePlateNumber, vehicleModel: $vehicleModel, vehicleColor: $vehicleColor, identityVerifiedAt: $identityVerifiedAt, driverLicenseVerifiedAt: $driverLicenseVerifiedAt, vehicleVerifiedAt: $vehicleVerifiedAt, selfieWithIdVerifiedAt: $selfieWithIdVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserVerificationImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.identityVerified, identityVerified) ||
                other.identityVerified == identityVerified) &&
            (identical(other.driverLicenseVerified, driverLicenseVerified) ||
                other.driverLicenseVerified == driverLicenseVerified) &&
            (identical(other.vehicleVerified, vehicleVerified) ||
                other.vehicleVerified == vehicleVerified) &&
            (identical(other.selfieWithIdVerified, selfieWithIdVerified) ||
                other.selfieWithIdVerified == selfieWithIdVerified) &&
            (identical(other.identityDocumentUrl, identityDocumentUrl) ||
                other.identityDocumentUrl == identityDocumentUrl) &&
            (identical(other.driverLicenseUrl, driverLicenseUrl) ||
                other.driverLicenseUrl == driverLicenseUrl) &&
            (identical(other.vehicleRegistrationUrl, vehicleRegistrationUrl) ||
                other.vehicleRegistrationUrl == vehicleRegistrationUrl) &&
            (identical(other.selfieWithIdUrl, selfieWithIdUrl) ||
                other.selfieWithIdUrl == selfieWithIdUrl) &&
            (identical(other.vehiclePlateNumber, vehiclePlateNumber) ||
                other.vehiclePlateNumber == vehiclePlateNumber) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleColor, vehicleColor) ||
                other.vehicleColor == vehicleColor) &&
            (identical(other.identityVerifiedAt, identityVerifiedAt) ||
                other.identityVerifiedAt == identityVerifiedAt) &&
            (identical(
                  other.driverLicenseVerifiedAt,
                  driverLicenseVerifiedAt,
                ) ||
                other.driverLicenseVerifiedAt == driverLicenseVerifiedAt) &&
            (identical(other.vehicleVerifiedAt, vehicleVerifiedAt) ||
                other.vehicleVerifiedAt == vehicleVerifiedAt) &&
            (identical(other.selfieWithIdVerifiedAt, selfieWithIdVerifiedAt) ||
                other.selfieWithIdVerifiedAt == selfieWithIdVerifiedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    userId,
    emailVerified,
    phoneVerified,
    identityVerified,
    driverLicenseVerified,
    vehicleVerified,
    selfieWithIdVerified,
    identityDocumentUrl,
    driverLicenseUrl,
    vehicleRegistrationUrl,
    selfieWithIdUrl,
    vehiclePlateNumber,
    vehicleModel,
    vehicleColor,
    identityVerifiedAt,
    driverLicenseVerifiedAt,
    vehicleVerifiedAt,
    selfieWithIdVerifiedAt,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of UserVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserVerificationImplCopyWith<_$UserVerificationImpl> get copyWith =>
      __$$UserVerificationImplCopyWithImpl<_$UserVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserVerificationImplToJson(this);
  }
}

abstract class _UserVerification extends UserVerification {
  const factory _UserVerification({
    required final String userId,
    final bool emailVerified,
    final bool phoneVerified,
    final bool identityVerified,
    final bool driverLicenseVerified,
    final bool vehicleVerified,
    final bool selfieWithIdVerified,
    final String? identityDocumentUrl,
    final String? driverLicenseUrl,
    final String? vehicleRegistrationUrl,
    final String? selfieWithIdUrl,
    final String? vehiclePlateNumber,
    final String? vehicleModel,
    final String? vehicleColor,
    final DateTime? identityVerifiedAt,
    final DateTime? driverLicenseVerifiedAt,
    final DateTime? vehicleVerifiedAt,
    final DateTime? selfieWithIdVerifiedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$UserVerificationImpl;
  const _UserVerification._() : super._();

  factory _UserVerification.fromJson(Map<String, dynamic> json) =
      _$UserVerificationImpl.fromJson;

  @override
  String get userId;
  @override
  bool get emailVerified;
  @override
  bool get phoneVerified;
  @override
  bool get identityVerified;
  @override
  bool get driverLicenseVerified;
  @override
  bool get vehicleVerified;
  @override
  bool get selfieWithIdVerified;
  @override
  String? get identityDocumentUrl;
  @override
  String? get driverLicenseUrl;
  @override
  String? get vehicleRegistrationUrl;
  @override
  String? get selfieWithIdUrl;
  @override
  String? get vehiclePlateNumber;
  @override
  String? get vehicleModel;
  @override
  String? get vehicleColor;
  @override
  DateTime? get identityVerifiedAt;
  @override
  DateTime? get driverLicenseVerifiedAt;
  @override
  DateTime? get vehicleVerifiedAt;
  @override
  DateTime? get selfieWithIdVerifiedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UserVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserVerificationImplCopyWith<_$UserVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
