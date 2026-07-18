import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_model.freezed.dart';
part 'verification_model.g.dart';

enum VerificationStatus { pending, approved, rejected, expired }
enum VerificationType { email, phone, identity, driverLicense, vehicle, selfieWithId }

@freezed
class VerificationModel with _$VerificationModel {
  const factory VerificationModel({
    required String id,
    required String oderId,
    required VerificationType type,
    required VerificationStatus status,
    String? documentUrl,
    String? documentNumber,
    String? rejectionReason,
    DateTime? expiryDate,
    DateTime? verifiedAt,
    String? verifiedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VerificationModel;

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationModelFromJson(json);
}

@freezed
class UserVerification with _$UserVerification {
  const UserVerification._();

  const factory UserVerification({
    required String userId,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    @Default(false) bool identityVerified,
    @Default(false) bool driverLicenseVerified,
    @Default(false) bool vehicleVerified,
    @Default(false) bool selfieWithIdVerified,
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
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserVerification;

  factory UserVerification.fromJson(Map<String, dynamic> json) =>
      _$UserVerificationFromJson(json);

  /// Get verification level (0-4)
  int get verificationLevel {
    int level = 0;
    if (emailVerified && phoneVerified) level = 1;
    if (level == 1 && identityVerified) level = 2;
    if (level == 2 && selfieWithIdVerified) level = 3;
    if (level == 3 && (driverLicenseVerified || vehicleVerified)) level = 4;
    return level;
  }

  /// Get verification badge text
  String get badgeText {
    switch (verificationLevel) {
      case 0:
        return 'Unverified';
      case 1:
        return 'Basic Verified';
      case 2:
        return 'ID Verified';
      case 3:
        return 'Selfie Verified';
      case 4:
        return 'Fully Verified';
      default:
        return 'Unverified';
    }
  }

  /// Check if user can be a driver (requires driver license)
  bool get canBeDriver => identityVerified && selfieWithIdVerified && driverLicenseVerified;

  /// Check if user can be a courier (requires vehicle registration)
  bool get canBeCourier => identityVerified && selfieWithIdVerified && vehicleVerified;

  /// Check if user can be matched - requires all basic verifications
  /// Driver/vehicle verification is checked separately based on user's role
  bool get canBeMatched => emailVerified && phoneVerified && identityVerified && selfieWithIdVerified;
}

