/// Input validators
class Validators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email is required';
    }
    if (!value!.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Password is required';
    }
    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate phone
  static String? validatePhone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Phone number is required';
    }
    if (value!.replaceAll(RegExp(r'[^\d+]'), '').length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Name is required';
    }
    if (value!.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value?.isEmpty ?? true) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate password match
  static String? validatePasswordMatch(String? value, String otherValue) {
    if (value?.isEmpty ?? true) {
      return 'Please confirm your password';
    }
    if (value != otherValue) {
      return 'Passwords do not match';
    }
    return null;
  }
}
