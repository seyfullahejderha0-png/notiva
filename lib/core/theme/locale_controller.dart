import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui' as ui;

const String _localeBoxName = 'settings_box';
const String _localeKey = 'app_locale';

final List<Locale> supportedLocales = const [
  Locale('tr'),
  Locale('en'),
  Locale('de'),
  Locale('fr'),
  Locale('it'),
  Locale('es'),
  Locale('pt'),
];

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(_getInitialLocale());

  static Locale _getInitialLocale() {
    final box = Hive.box(_localeBoxName);
    final savedLang = box.get(_localeKey);
    
    if (savedLang != null) {
      return Locale(savedLang);
    } else {
      // Get system language
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      if (supportedLocales.any((l) => l.languageCode == systemLocale.languageCode)) {
        return Locale(systemLocale.languageCode);
      } else {
        return const Locale('tr');
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    final box = Hive.box(_localeBoxName);
    await box.put(_localeKey, locale.languageCode);
    state = locale;
  }
}

final localeControllerProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController();
});
