/// String extensions
extension StringExtensions on String {
  /// Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(this);
  }
  
  /// Check if string is phone number (basic validation)
  bool get isPhoneNumber {
    return replaceAll(RegExp(r'[^\d+]'), '').length >= 7;
  }
  
  /// Check if string is not blank (not empty and not just whitespace)
  bool get isNotBlank => length > 0 && trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}

/// Num extensions
extension NumExtensions on num {
  /// Format as currency
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }
}

/// Duration extensions
extension DurationExtensions on Duration {
  /// Format duration as MM:SS or HH:MM:SS
  String toFormattedString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    if (inHours > 0) {
      return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    }
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  /// Get formatted time (12:34 PM)
  String get formattedTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
