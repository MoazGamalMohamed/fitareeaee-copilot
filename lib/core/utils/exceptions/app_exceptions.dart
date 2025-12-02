class AppException implements Exception {
  final String message;

  AppException({this.message = 'An unexpected error occurred'});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error']) : super(message: message);
}

class UserNotFoundException extends AppException {
  UserNotFoundException([String message = 'User not found']) : super(message: message);
}
