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
}
