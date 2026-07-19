import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings state
class SettingsState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final List<String> preferredLanguages;
  final String currency;
  final bool locationSharingEnabled;
  final bool soundEnabled;
  final bool savePaymentMethod;

  const SettingsState({
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.language = 'en',
    this.preferredLanguages = const ['en'],
    this.currency = 'USD',
    this.locationSharingEnabled = true,
    this.soundEnabled = true,
    this.savePaymentMethod = false,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    List<String>? preferredLanguages,
    String? currency,
    bool? locationSharingEnabled,
    bool? soundEnabled,
    bool? savePaymentMethod,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      currency: currency ?? this.currency,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      savePaymentMethod: savePaymentMethod ?? this.savePaymentMethod,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
      darkModeEnabled: prefs.getBool('dark_mode_enabled') ?? false,
      language: prefs.getString('language') ?? 'en',
      preferredLanguages:
          prefs.getStringList('preferred_languages') ?? const ['en'],
      currency: prefs.getString('currency') ?? 'USD',
      locationSharingEnabled: prefs.getBool('location_sharing_enabled') ?? true,
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
      savePaymentMethod: prefs.getBool('save_payment_method') ?? false,
    );
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> setDarkModeEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', value);
    state = state.copyWith(darkModeEnabled: value);
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    state = state.copyWith(language: value);
  }

  Future<void> togglePreferredLanguage(String value) async {
    final current = {...state.preferredLanguages};
    if (current.contains(value) && current.length > 1) {
      current.remove(value);
    } else {
      current.add(value);
    }
    final ordered = [
      'en',
      'ar',
    ].where((language) => current.contains(language)).toList(growable: false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('preferred_languages', ordered);
    state = state.copyWith(
      preferredLanguages: ordered,
      language: ordered.first,
    );
  }

  Future<void> setCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', value);
    state = state.copyWith(currency: value);
  }

  Future<void> setLocationSharingEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_sharing_enabled', value);
    state = state.copyWith(locationSharingEnabled: value);
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', value);
    state = state.copyWith(soundEnabled: value);
  }

  Future<void> setSavePaymentMethod(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('save_payment_method', value);
    state = state.copyWith(savePaymentMethod: value);
  }
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);
