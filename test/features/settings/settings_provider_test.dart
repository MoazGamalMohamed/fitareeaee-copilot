import 'package:fitareeaee/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('settings actions update state and persist their values', () async {
    SharedPreferences.setMockInitialValues({});
    final notifier = SettingsNotifier();
    addTearDown(notifier.dispose);
    await Future<void>.delayed(Duration.zero);

    await notifier.togglePreferredLanguage('ar');
    await notifier.setCurrency('EUR');
    await notifier.setNotificationsEnabled(false);
    await notifier.setLocationSharingEnabled(false);
    await notifier.setSavePaymentMethod(true);

    final preferences = await SharedPreferences.getInstance();
    expect(notifier.state.preferredLanguages, ['en', 'ar']);
    expect(notifier.state.currency, 'EUR');
    expect(notifier.state.notificationsEnabled, isFalse);
    expect(notifier.state.locationSharingEnabled, isFalse);
    expect(notifier.state.savePaymentMethod, isTrue);
    expect(preferences.getStringList('preferred_languages'), ['en', 'ar']);
    expect(preferences.getString('currency'), 'EUR');
    expect(preferences.getBool('notifications_enabled'), isFalse);
    expect(preferences.getBool('location_sharing_enabled'), isFalse);
    expect(preferences.getBool('save_payment_method'), isTrue);
  });

  test('at least one preferred language always remains selected', () async {
    SharedPreferences.setMockInitialValues({
      'preferred_languages': <String>['en'],
    });
    final notifier = SettingsNotifier();
    addTearDown(notifier.dispose);
    await Future<void>.delayed(Duration.zero);

    await notifier.togglePreferredLanguage('en');

    expect(notifier.state.preferredLanguages, ['en']);
  });
}
