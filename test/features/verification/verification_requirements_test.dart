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
}) => UserVerification(
  userId: 'user',
  emailVerified: email,
  phoneVerified: phone,
  identityVerified: identity,
  selfieWithIdVerified: selfie,
  driverLicenseVerified: licence,
  vehicleVerified: vehicle,
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
}
