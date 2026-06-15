import 'package:flutter/material.dart';

/// Notiva uygulaması için yumuşak mavi (soft-blue) renk paleti.
class AppColors {
  AppColors._();

  // ─── Ana Renkler ───
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primarySurface = Color(0xFF3B82F6);

  // ─── İkincil Renkler ───
  static const Color secondary = Color(0xFFDBEAFE);
  static const Color secondaryLight = Color(0xFFEFF6FF);

  // ─── Yüzey & Arka Plan (Açık Tema) ───
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceHover = Color(0xFFE2E8F0);

  // ─── Metin Renkleri ───
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Durum Renkleri ───
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color critical = Color(0xFFDC2626);

  // ─── Çizgiler & Gölgeler ───
  static const Color divider = Color(0xFFE2E8F0);
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // ─── Koyu Tema ───
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkSurfaceHover = Color(0xFF475569);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color darkDivider = Color(0xFF334155);

  // ─── Öncelik Renkleri ───
  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFF97316);
  static const Color priorityCritical = Color(0xFFEF4444);

  // ─── Durum Renkleri (Görev) ───
  static const Color statusPending = Color(0xFF94A3B8);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFEF4444);

  // ─── Gradyanlar ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [secondaryLight, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Modern Glass/Pastel Gradients ───
  static const LinearGradient glassBlue = LinearGradient(
    colors: [Color(0xFFDBEAFE), Color(0xFFEFF6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassPurple = LinearGradient(
    colors: [Color(0xFFE0E7FF), Color(0xFFEEF2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGreen = LinearGradient(
    colors: [Color(0xFFD1FAE5), Color(0xFFECFDF5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassOrange = LinearGradient(
    colors: [Color(0xFFFFEDD5), Color(0xFFFFF7ED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Workspace Renk Seçenekleri ───
  static const List<Color> workspaceColors = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFEC4899),
    Color(0xFFF97316),
    Color(0xFF10B981),
    Color(0xFF06B6D4),
    Color(0xFFEAB308),
    Color(0xFF6366F1),
  ];
}
