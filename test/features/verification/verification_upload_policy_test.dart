import 'package:fitareeaee/features/verification/domain/verification_upload_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('verification images must be non-empty and strictly below 5 MiB', () {
    expect(isVerificationImageSizeAllowed(0), isFalse);
    expect(isVerificationImageSizeAllowed(1), isTrue);
    expect(
      isVerificationImageSizeAllowed(verificationImageMaxBytes - 1),
      isTrue,
    );
    expect(
      isVerificationImageSizeAllowed(verificationImageMaxBytes),
      isFalse,
    );
    expect(
      isVerificationImageSizeAllowed(verificationImageMaxBytes + 1),
      isFalse,
    );
  });

  test('capture dimensions are bounded for high-resolution phone cameras', () {
    expect(verificationImageMaxDimension, 2048);
  });
}
