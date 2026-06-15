import 'package:flutter/foundation.dart';

// ── State ──────────────────────────────────────────────────────────────

class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;
  final String appVersion;

  const SettingsState({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.language = 'tr',
    this.appVersion = '1.0.0',
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
    String? appVersion,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.isDarkMode == isDarkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.language == language &&
        other.appVersion == appVersion;
  }

  @override
  int get hashCode =>
      Object.hash(isDarkMode, notificationsEnabled, language, appVersion);
}

// ── Controller ─────────────────────────────────────────────────────────

class SettingsController extends ChangeNotifier {
  SettingsState _state = const SettingsState();
  SettingsState get state => _state;

  void toggleDarkMode() {
    _state = _state.copyWith(isDarkMode: !_state.isDarkMode);
    notifyListeners();
  }

  void toggleNotifications() {
    _state = _state.copyWith(
      notificationsEnabled: !_state.notificationsEnabled,
    );
    notifyListeners();
  }

  void setLanguage(String lang) {
    _state = _state.copyWith(language: lang);
    notifyListeners();
  }
}

// ── Provider ───────────────────────────────────────────────────────────
// Wire via:
//   final settingsControllerProvider = ChangeNotifierProvider((ref) => SettingsController());
