import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings state
class SettingsState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final bool locationSharingEnabled;
  final bool soundEnabled;

  const SettingsState({
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.language = 'en',
    this.locationSharingEnabled = true,
    this.soundEnabled = true,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    bool? locationSharingEnabled,
    bool? soundEnabled,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
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
      locationSharingEnabled: prefs.getBool('location_sharing_enabled') ?? true,
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
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
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);
