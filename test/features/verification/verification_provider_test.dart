import 'package:flutter_test/flutter_test.dart';
import 'package:fitareeaee/features/verification/presentation/providers/verification_provider.dart';

void main() {
  test('legacy verified document remains usable without createdAt', () {
    final updatedAt = DateTime.utc(2026, 7, 20, 8, 30);

    final verification = userVerificationFromFirestoreData('judge-rider', {
      'identityVerified': true,
      'selfieWithIdVerified': true,
      'emailVerified': true,
      'updatedAt': updatedAt,
    });

    expect(verification.userId, 'judge-rider');
    expect(verification.identityVerified, isTrue);
    expect(verification.selfieWithIdVerified, isTrue);
    expect(verification.createdAt, updatedAt);
    expect(verification.updatedAt, updatedAt);
  });

  test('missing audit timestamps receive a stable legacy fallback', () {
    final verification = userVerificationFromFirestoreData('legacy-user', {
      'identityVerified': true,
    });

    expect(verification.createdAt, DateTime.utc(1970));
    expect(verification.updatedAt, verification.createdAt);
  });

  test(
    'explicit null and malformed legacy fields never trigger string casts',
    () {
      final verification = userVerificationFromFirestoreData(
        'legacy-null-user',
        {
          'emailVerified': 'true',
          'phoneVerified': 1,
          'identityVerified': null,
          'selfieWithIdVerified': false,
          'identityDocumentUrl': null,
          'driverLicenseUrl': 42,
          'vehicleRegistrationUrl': '',
          'vehiclePlateNumber': null,
          'identityVerifiedAt': null,
          'createdAt': null,
          'updatedAt': {'seconds': 100, 'nanoseconds': 0},
        },
      );

      expect(verification.userId, 'legacy-null-user');
      expect(verification.emailVerified, isTrue);
      expect(verification.phoneVerified, isTrue);
      expect(verification.identityVerified, isFalse);
      expect(verification.identityDocumentUrl, isNull);
      expect(verification.driverLicenseUrl, isNull);
      expect(verification.vehicleRegistrationUrl, isNull);
      expect(
        verification.createdAt,
        DateTime.fromMillisecondsSinceEpoch(100000, isUtc: true),
      );
      expect(verification.updatedAt, verification.createdAt);
    },
  );
}
