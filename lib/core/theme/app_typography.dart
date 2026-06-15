import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notiva uygulaması tipografi sistemi — Inter font ailesi.
class AppTypography {
  AppTypography._();

  static String fontFamily = 'Inter';

  static TextStyle get _baseStyle {
    try {
      return GoogleFonts.getFont(fontFamily);
    } catch (e) {
      return GoogleFonts.inter();
    }
  }

  // ─── Display ───
  static TextStyle get displayLarge => _baseStyle.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => _baseStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      );

  static TextStyle get displaySmall => _baseStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      );

  // ─── Headline ───
  static TextStyle get headlineLarge => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineMedium => _baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineSmall => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  // ─── Title ───
  static TextStyle get titleLarge => _baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get titleSmall => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ─── Body ───
  static TextStyle get bodyLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ─── Label ───
  static TextStyle get labelLarge => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => _baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
      );

  /// Seçilen fonta göre TextTheme döndürür.
  static TextTheme getTextTheme(String font) {
    fontFamily = font; // Statik referansı da güncelleriz, böylece doğrudan static metod çağrıları da doğru fontu alır.
    
    final baseTheme = TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );

    try {
      return GoogleFonts.getTextTheme(font, baseTheme);
    } catch (e) {
      return GoogleFonts.interTextTheme(baseTheme);
    }
  }
}
