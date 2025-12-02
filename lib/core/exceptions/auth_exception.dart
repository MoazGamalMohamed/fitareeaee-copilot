/// Custom exceptions for authentication
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

class UserNotFoundException extends AuthException {
  UserNotFoundException({String message = 'User not found'})
      : super(message: message, code: 'user_not_found');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException({String message = 'Invalid email or password'})
      : super(message: message, code: 'invalid_credentials');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException({String message = 'Email already in use'})
      : super(message: message, code: 'email_already_in_use');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException({String message = 'Password is too weak'})
      : super(message: message, code: 'weak_password');
}

class NetworkException extends AuthException {
  NetworkException({String message = 'Network error'})
      : super(message: message, code: 'network_error');
}

class FirebaseAuthException extends AuthException {
  FirebaseAuthException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
