import 'models/verification_model.dart';

/// The minimum manual review required before any participant can publish a
/// request or enter the booking lifecycle.
bool participantTripVerificationComplete(UserVerification? verification) =>
    (verification?.emailVerified ?? false) &&
    (verification?.phoneVerified ?? false) &&
    (verification?.identityVerified ?? false) &&
    (verification?.selfieWithIdVerified ?? false);

/// Drivers/couriers carry the additional licence and vehicle obligations.
bool driverTripVerificationComplete(UserVerification? verification) =>
    participantTripVerificationComplete(verification) &&
    (verification?.driverLicenseVerified ?? false) &&
    (verification?.vehicleVerified ?? false);

int tripVerificationTotalSteps({required bool driver}) => driver ? 6 : 4;

int approvedTripVerificationStepCount(
  UserVerification? verification, {
  required bool driver,
}) {
  if (verification == null) return 0;
  return [
    verification.emailVerified,
    verification.phoneVerified,
    verification.identityVerified,
    verification.selfieWithIdVerified,
    if (driver) verification.driverLicenseVerified,
    if (driver) verification.vehicleVerified,
  ].where((approved) => approved).length;
}

int pendingTripVerificationStepCount(
  UserVerification? verification, {
  required bool driver,
}) {
  if (verification == null) return 0;
  return [
    verification.identityDocumentUrl != null && !verification.identityVerified,
    verification.selfieWithIdUrl != null && !verification.selfieWithIdVerified,
    if (driver)
      verification.driverLicenseUrl != null &&
          !verification.driverLicenseVerified,
    if (driver)
      verification.vehicleRegistrationUrl != null &&
          !verification.vehicleVerified,
  ].where((pending) => pending).length;
}

int submittedTripVerificationStepCount(
  UserVerification? verification, {
  required bool driver,
}) =>
    approvedTripVerificationStepCount(verification, driver: driver) +
    pendingTripVerificationStepCount(verification, driver: driver);

List<String> missingTripVerificationItems(
  UserVerification? verification, {
  required bool driver,
}) => [
  if (!(verification?.emailVerified ?? false)) 'email address',
  if (!(verification?.phoneVerified ?? false)) 'phone number',
  if (!(verification?.identityVerified ?? false)) 'identity document',
  if (!(verification?.selfieWithIdVerified ?? false)) 'selfie with ID',
  if (driver && !(verification?.driverLicenseVerified ?? false))
    'driver licence',
  if (driver && !(verification?.vehicleVerified ?? false))
    'vehicle registration',
];
