/// Generic result wrapper for operations
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) error,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(message: final message, code: final code) => error(message, code),
    };
  }

  T? getOrNull() {
    return switch (this) {
      Success(data: final data) => data,
      Failure() => null,
    };
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });
}
