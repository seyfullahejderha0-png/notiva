import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _themeBoxName = 'settings_box';
const String _themeKey = 'theme_mode';
const String _fontKey = 'font_family';

class ThemeState {
  final ThemeMode mode;
  final String fontFamily;

  const ThemeState({this.mode = ThemeMode.system, this.fontFamily = 'Inter'});

  ThemeState copyWith({ThemeMode? mode, String? fontFamily}) {
    return ThemeState(
      mode: mode ?? this.mode,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

class ThemeController extends StateNotifier<ThemeState> {
  ThemeController() : super(const ThemeState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(_themeBoxName);
    final themeIndex = box.get(_themeKey, defaultValue: ThemeMode.system.index);
    final fontFamily = box.get(_fontKey, defaultValue: 'Inter');
    state = ThemeState(mode: ThemeMode.values[themeIndex], fontFamily: fontFamily);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_themeKey, mode.index);
    state = state.copyWith(mode: mode);
  }

  Future<void> setFontFamily(String font) async {
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_fontKey, font);
    state = state.copyWith(fontFamily: font);
  }
}

final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeState>((ref) {
  return ThemeController();
});
