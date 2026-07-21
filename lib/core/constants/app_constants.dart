/// App-wide constants
class AppConstants {
  // App metadata
  static const String appName = 'Fitareeaee';
  static const String appVersion = '1.0.20';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Pagination
  static const int pageSize = 20;
  static const int maxPages = 100;

  // Map defaults
  static const double defaultMapZoom = 15.0;
  static const double defaultMapPadding = 100.0;

  // Chat
  static const int maxMessageLength = 500;
  static const int maxImageUploadSize = 10 * 1024 * 1024; // 10 MB

  // Trip
  static const double minTripDistance = 0.1; // km
  static const double maxTripDistance = 1000; // km

  // Payment
  static const double minPaymentAmount = 0.50;
  static const double maxPaymentAmount = 99999.99;
  static const List<String> supportedCurrencies = ['USD', 'AED', 'SAR'];

  // Rating
  static const int minRatingValue = 1;
  static const int maxRatingValue = 5;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 1);
}
