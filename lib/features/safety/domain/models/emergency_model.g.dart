// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmergencyAlertImpl _$$EmergencyAlertImplFromJson(Map<String, dynamic> json) =>
    _$EmergencyAlertImpl(
      id: json['id'] as String,
      oderId: json['oderId'] as String,
      tripId: json['tripId'] as String?,
      type: $enumDecode(_$EmergencyTypeEnumMap, json['type']),
      status: $enumDecode(_$EmergencyStatusEnumMap, json['status']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolvedBy: json['resolvedBy'] as String?,
      resolutionNotes: json['resolutionNotes'] as String?,
    );

Map<String, dynamic> _$$EmergencyAlertImplToJson(
  _$EmergencyAlertImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'oderId': instance.oderId,
  'tripId': instance.tripId,
  'type': _$EmergencyTypeEnumMap[instance.type]!,
  'status': _$EmergencyStatusEnumMap[instance.status]!,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'description': instance.description,
  'emergencyContacts': instance.emergencyContacts,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
  'resolvedBy': instance.resolvedBy,
  'resolutionNotes': instance.resolutionNotes,
};

const _$EmergencyTypeEnumMap = {
  EmergencyType.accident: 'accident',
  EmergencyType.harassment: 'harassment',
  EmergencyType.theft: 'theft',
  EmergencyType.medical: 'medical',
  EmergencyType.other: 'other',
};

const _$EmergencyStatusEnumMap = {
  EmergencyStatus.active: 'active',
  EmergencyStatus.resolved: 'resolved',
  EmergencyStatus.cancelled: 'cancelled',
};

_$EmergencyContactImpl _$$EmergencyContactImplFromJson(
  Map<String, dynamic> json,
) => _$EmergencyContactImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  relationship: json['relationship'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$EmergencyContactImplToJson(
  _$EmergencyContactImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'phone': instance.phone,
  'relationship': instance.relationship,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$SafetySettingsImpl _$$SafetySettingsImplFromJson(Map<String, dynamic> json) =>
    _$SafetySettingsImpl(
      sosEnabled: json['sosEnabled'] as bool? ?? true,
      shareLocationOnSOS: json['shareLocationOnSOS'] as bool? ?? true,
      notifyEmergencyContacts: json['notifyEmergencyContacts'] as bool? ?? true,
      autoCallEmergency: json['autoCallEmergency'] as bool? ?? true,
      emergencyNumber: json['emergencyNumber'] as String?,
      emergencyContacts:
          (json['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SafetySettingsImplToJson(
  _$SafetySettingsImpl instance,
) => <String, dynamic>{
  'sosEnabled': instance.sosEnabled,
  'shareLocationOnSOS': instance.shareLocationOnSOS,
  'notifyEmergencyContacts': instance.notifyEmergencyContacts,
  'autoCallEmergency': instance.autoCallEmergency,
  'emergencyNumber': instance.emergencyNumber,
  'emergencyContacts': instance.emergencyContacts,
};
