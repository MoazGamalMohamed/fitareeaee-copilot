import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_model.freezed.dart';
part 'emergency_model.g.dart';

enum EmergencyStatus { active, resolved, cancelled }

enum EmergencyType { accident, harassment, theft, medical, other }

@freezed
class EmergencyAlert with _$EmergencyAlert {
  const EmergencyAlert._();

  const factory EmergencyAlert({
    required String id,
    required String oderId,
    String? tripId,
    required EmergencyType type,
    required EmergencyStatus status,
    required double latitude,
    required double longitude,
    String? description,
    List<String>? emergencyContacts,
    required DateTime createdAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
  }) = _EmergencyAlert;

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertFromJson(json);

  bool get isActive => status == EmergencyStatus.active;
}

@freezed
class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required String id,
    required String userId,
    required String name,
    required String phone,
    String? relationship,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}

@freezed
class SafetySettings with _$SafetySettings {
  const factory SafetySettings({
    @Default(true) bool sosEnabled,
    @Default(true) bool shareLocationOnSOS,
    @Default(true) bool notifyEmergencyContacts,
    @Default(true) bool autoCallEmergency,
    String? emergencyNumber,
    @Default([]) List<EmergencyContact> emergencyContacts,
  }) = _SafetySettings;

  factory SafetySettings.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingsFromJson(json);
}
