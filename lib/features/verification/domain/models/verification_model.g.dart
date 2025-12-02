// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationModelImpl _$$VerificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$VerificationModelImpl(
  id: json['id'] as String,
  oderId: json['oderId'] as String,
  type: $enumDecode(_$VerificationTypeEnumMap, json['type']),
  status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
  documentUrl: json['documentUrl'] as String?,
  documentNumber: json['documentNumber'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  verifiedBy: json['verifiedBy'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$VerificationModelImplToJson(
  _$VerificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'oderId': instance.oderId,
  'type': _$VerificationTypeEnumMap[instance.type]!,
  'status': _$VerificationStatusEnumMap[instance.status]!,
  'documentUrl': instance.documentUrl,
  'documentNumber': instance.documentNumber,
  'rejectionReason': instance.rejectionReason,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'verifiedBy': instance.verifiedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$VerificationTypeEnumMap = {
  VerificationType.email: 'email',
  VerificationType.phone: 'phone',
  VerificationType.identity: 'identity',
  VerificationType.driverLicense: 'driverLicense',
  VerificationType.vehicle: 'vehicle',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.expired: 'expired',
};

_$UserVerificationImpl _$$UserVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$UserVerificationImpl(
  userId: json['userId'] as String,
  emailVerified: json['emailVerified'] as bool? ?? false,
  phoneVerified: json['phoneVerified'] as bool? ?? false,
  identityVerified: json['identityVerified'] as bool? ?? false,
  driverLicenseVerified: json['driverLicenseVerified'] as bool? ?? false,
  vehicleVerified: json['vehicleVerified'] as bool? ?? false,
  identityDocumentUrl: json['identityDocumentUrl'] as String?,
  driverLicenseUrl: json['driverLicenseUrl'] as String?,
  vehicleRegistrationUrl: json['vehicleRegistrationUrl'] as String?,
  vehiclePlateNumber: json['vehiclePlateNumber'] as String?,
  vehicleModel: json['vehicleModel'] as String?,
  vehicleColor: json['vehicleColor'] as String?,
  identityVerifiedAt: json['identityVerifiedAt'] == null
      ? null
      : DateTime.parse(json['identityVerifiedAt'] as String),
  driverLicenseVerifiedAt: json['driverLicenseVerifiedAt'] == null
      ? null
      : DateTime.parse(json['driverLicenseVerifiedAt'] as String),
  vehicleVerifiedAt: json['vehicleVerifiedAt'] == null
      ? null
      : DateTime.parse(json['vehicleVerifiedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$UserVerificationImplToJson(
  _$UserVerificationImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'emailVerified': instance.emailVerified,
  'phoneVerified': instance.phoneVerified,
  'identityVerified': instance.identityVerified,
  'driverLicenseVerified': instance.driverLicenseVerified,
  'vehicleVerified': instance.vehicleVerified,
  'identityDocumentUrl': instance.identityDocumentUrl,
  'driverLicenseUrl': instance.driverLicenseUrl,
  'vehicleRegistrationUrl': instance.vehicleRegistrationUrl,
  'vehiclePlateNumber': instance.vehiclePlateNumber,
  'vehicleModel': instance.vehicleModel,
  'vehicleColor': instance.vehicleColor,
  'identityVerifiedAt': instance.identityVerifiedAt?.toIso8601String(),
  'driverLicenseVerifiedAt': instance.driverLicenseVerifiedAt
      ?.toIso8601String(),
  'vehicleVerifiedAt': instance.vehicleVerifiedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
