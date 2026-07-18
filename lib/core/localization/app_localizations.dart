import 'package:flutter/material.dart';

/// App localization strings - English (default)
class AppLocalizations {
  static const Map<String, String> en = {
    // App
    'app_name': 'Fitareeaee',

    // Auth
    'auth_email': 'Email',
    'auth_password': 'Password',
    'auth_login': 'Login',
    'auth_register': 'Register',
    'auth_signup': 'Sign Up',
    'auth_forgot_password': 'Forgot Password?',
    'auth_no_account': 'Don\'t have an account?',
    'auth_have_account': 'Already have an account?',
    'auth_error_invalid_email': 'Please enter a valid email',
    'auth_error_weak_password': 'Password is too weak',
    'auth_error_email_in_use': 'Email is already in use',

    // Home
    'home_title': 'Home',
    'home_search_trips': 'Search trips',
    'home_recent_trips': 'Recent trips',
    'home_no_trips': 'No trips yet',

    // Trips
    'trip_from': 'From',
    'trip_to': 'To',
    'trip_date': 'Date',
    'trip_time': 'Time',
    'trip_seats': 'Seats',
    'trip_price': 'Price',
    'trip_distance': 'Distance',
    'trip_duration': 'Duration',
    'trip_create': 'Create Trip',
    'trip_search': 'Search Trips',
    'trip_book': 'Book',
    'trip_cancel': 'Cancel',

    // Chat
    'chat_messages': 'Messages',
    'chat_send': 'Send',
    'chat_type_message': 'Type a message',
    'chat_no_messages': 'No messages yet',

    // Payment
    'payment_amount': 'Amount',
    'payment_pay': 'Pay',
    'payment_success': 'Payment successful',
    'payment_failed': 'Payment failed',
    'payment_pending': 'Payment pending',

    // Profile
    'profile_title': 'Profile',
    'profile_edit': 'Edit Profile',
    'profile_name': 'Name',
    'profile_phone': 'Phone',
    'profile_rating': 'Rating',
    'profile_trips': 'Total Trips',
    'profile_logout': 'Logout',

    // Ratings
    'rating_rate': 'Rate',
    'rating_add_review': 'Add Review',
    'rating_excellent': 'Excellent',
    'rating_good': 'Good',
    'rating_average': 'Average',
    'rating_poor': 'Poor',

    // Common
    'common_loading': 'Loading...',
    'common_error': 'Error',
    'common_success': 'Success',
    'common_close': 'Close',
    'common_save': 'Save',
    'common_cancel': 'Cancel',
    'common_delete': 'Delete',
    'common_edit': 'Edit',
    'common_confirm': 'Confirm',
    'common_back': 'Back',
    'common_ok': 'OK',
  };

  /// Get localized string by key
  static String getString(String key, [Locale? locale]) {
    // TODO: Add Arabic and other languages support
    return en[key] ?? key;
  }
}
