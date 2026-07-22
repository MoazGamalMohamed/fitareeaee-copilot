import 'package:fitareeaee/features/verification/domain/models/verification_model.dart';
import 'package:fitareeaee/features/verification/domain/verification_requirements.dart';
import 'package:flutter_test/flutter_test.dart';

UserVerification verification({
  bool email = false,
  bool phone = false,
  bool identity = false,
  bool selfie = false,
  bool licence = false,
  bool vehicle = false,
  bool identitySubmitted = false,
  bool selfieSubmitted = false,
  bool licenceSubmitted = false,
  bool vehicleSubmitted = false,
}) => UserVerification(
  userId: 'user',
  emailVerified: email,
  phoneVerified: phone,
  identityVerified: identity,
  selfieWithIdVerified: selfie,
  driverLicenseVerified: licence,
  vehicleVerified: vehicle,
  identityDocumentUrl: identitySubmitted
      ? 'verification_documents/u/id.jpg'
      : null,
  selfieWithIdUrl: selfieSubmitted
      ? 'verification_documents/u/selfie.jpg'
      : null,
  driverLicenseUrl: licenceSubmitted
      ? 'verification_documents/u/licence.jpg'
      : null,
  vehicleRegistrationUrl: vehicleSubmitted
      ? 'verification_documents/u/vehicle.jpg'
      : null,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  test(
    'rider needs contact, identity, and selfie checks before publishing',
    () {
      expect(
        participantTripVerificationComplete(
          verification(email: true, phone: true, identity: true, selfie: true),
        ),
        isTrue,
      );
      expect(
        participantTripVerificationComplete(verification(identity: true)),
        isFalse,
      );
    },
  );

  test('driver additionally needs licence and vehicle approval', () {
    expect(
      driverTripVerificationComplete(
        verification(
          email: true,
          phone: true,
          identity: true,
          selfie: true,
          licence: true,
          vehicle: true,
        ),
      ),
      isTrue,
    );
    expect(
      driverTripVerificationComplete(
        verification(
          email: true,
          phone: true,
          identity: true,
          selfie: true,
          licence: true,
        ),
      ),
      isFalse,
    );
  });

  test('missing items are role-specific and readable', () {
    expect(missingTripVerificationItems(null, driver: false), [
      'email address',
      'phone number',
      'identity document',
      'selfie with ID',
    ]);
    expect(
      missingTripVerificationItems(
        verification(email: true, phone: true, identity: true, selfie: true),
        driver: true,
      ),
      ['driver licence', 'vehicle registration'],
    );
  });

  test('submitted, approved, and pending counts remain distinct', () {
    final status = verification(
      email: true,
      phone: true,
      identitySubmitted: true,
      selfieSubmitted: true,
      licenceSubmitted: true,
    );

    expect(tripVerificationTotalSteps(driver: true), 6);
    expect(approvedTripVerificationStepCount(status, driver: true), 2);
    expect(pendingTripVerificationStepCount(status, driver: true), 3);
    expect(submittedTripVerificationStepCount(status, driver: true), 5);
    expect(submittedTripVerificationStepCount(status, driver: false), 4);
  });
}
