const int verificationImageMaxBytes = 5 * 1024 * 1024;
const double verificationImageMaxDimension = 2048;

/// Mirrors the strict Firebase Storage and callable-function image limit.
bool isVerificationImageSizeAllowed(int bytes) =>
    bytes > 0 && bytes < verificationImageMaxBytes;
