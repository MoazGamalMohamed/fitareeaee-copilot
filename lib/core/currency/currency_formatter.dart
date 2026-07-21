import 'package:intl/intl.dart';

/// Currency display helper.
///
/// Trip and booking amounts remain canonical USD in Firebase. AED and SAR are
/// displayed using their official USD pegs, and values entered in those
/// currencies are converted back to USD before persistence.
class CurrencyFormatter {
  const CurrencyFormatter._();

  static const Map<String, double> usdRates = {
    'USD': 1,
    'AED': 3.6725,
    'SAR': 3.75,
  };

  static const Map<String, String> symbols = {
    'USD': r'$',
    'AED': 'د.إ',
    'SAR': 'ر.س',
  };

  static bool isSupported(String currency) => usdRates.containsKey(currency);

  static String normalizedCurrency(String currency) =>
      isSupported(currency) ? currency : 'USD';

  static double fromUsd(double amountUsd, String currency) {
    final normalized = normalizedCurrency(currency);
    return amountUsd * usdRates[normalized]!;
  }

  static double toUsd(double displayAmount, String currency) {
    final normalized = normalizedCurrency(currency);
    return displayAmount / usdRates[normalized]!;
  }

  static String formatUsd(
    double amountUsd,
    String currency, {
    String languageCode = 'en',
  }) {
    final normalized = normalizedCurrency(currency);
    final converted = fromUsd(amountUsd, normalized);
    final number = NumberFormat.decimalPatternDigits(
      locale: languageCode == 'ar' ? 'ar' : 'en_US',
      decimalDigits: 2,
    ).format(converted);
    return languageCode == 'ar'
        ? '$number ${symbols[normalized]}'
        : '${symbols[normalized]}$number $normalized';
  }

  static String inputLabel(String currency) {
    final normalized = normalizedCurrency(currency);
    return '$normalized (${symbols[normalized]})';
  }
}
