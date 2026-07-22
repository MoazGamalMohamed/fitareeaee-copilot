import 'package:fitareeaee/core/currency/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts selected display currencies to and from canonical USD', () {
    expect(CurrencyFormatter.fromUsd(10, 'AED'), closeTo(36.725, 0.0001));
    expect(CurrencyFormatter.toUsd(37.5, 'SAR'), closeTo(10, 0.0001));
    expect(CurrencyFormatter.toUsd(10, 'USD'), 10);
  });

  test('formats each supported currency with its unit', () {
    expect(CurrencyFormatter.formatUsd(10, 'USD'), contains('USD'));
    expect(CurrencyFormatter.formatUsd(10, 'AED'), contains('AED'));
    expect(
      CurrencyFormatter.formatUsd(10, 'SAR', languageCode: 'ar'),
      contains('ر.س'),
    );
  });

  test('unknown currencies cannot leak into persisted calculations', () {
    expect(CurrencyFormatter.normalizedCurrency('EUR'), 'USD');
    expect(CurrencyFormatter.toUsd(12, 'EUR'), 12);
  });
}
