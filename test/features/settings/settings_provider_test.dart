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
    await notifier.setLanguage('ar');
    await notifier.setCurrency('AED');
    await notifier.setNotificationsEnabled(false);
    await notifier.setLocationSharingEnabled(false);
    await notifier.setSavePaymentMethod(true);

    final preferences = await SharedPreferences.getInstance();
    expect(notifier.state.preferredLanguages, ['en', 'ar']);
    expect(notifier.state.language, 'ar');
    expect(notifier.state.currency, 'AED');
    expect(notifier.state.notificationsEnabled, isFalse);
    expect(notifier.state.locationSharingEnabled, isFalse);
    expect(notifier.state.savePaymentMethod, isTrue);
    expect(preferences.getStringList('preferred_languages'), ['en', 'ar']);
    expect(preferences.getString('language'), 'ar');
    expect(preferences.getString('currency'), 'AED');
    expect(preferences.getBool('notifications_enabled'), isFalse);
    expect(preferences.getBool('location_sharing_enabled'), isFalse);
    expect(preferences.getBool('save_payment_method'), isTrue);
  });

  test(
    'planning languages do not unexpectedly change the app language',
    () async {
      SharedPreferences.setMockInitialValues({'language': 'ar'});
      final notifier = SettingsNotifier();
      addTearDown(notifier.dispose);
      await Future<void>.delayed(Duration.zero);

      await notifier.togglePreferredLanguage('ar');

      expect(notifier.state.language, 'ar');
    },
  );

  test('unsupported language and currency values safely fall back', () async {
    SharedPreferences.setMockInitialValues({});
    final notifier = SettingsNotifier();
    addTearDown(notifier.dispose);
    await Future<void>.delayed(Duration.zero);

    await notifier.setLanguage('invalid');
    await notifier.setCurrency('EUR');

    expect(notifier.state.language, 'en');
    expect(notifier.state.currency, 'USD');
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
