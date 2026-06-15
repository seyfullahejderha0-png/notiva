import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeContextExt on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get textPrimary => isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get textSecondary => isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textTertiary => isDarkMode ? AppColors.darkTextTertiary : AppColors.textTertiary;
  
  Color get bgSurface => isDarkMode ? AppColors.darkSurface : AppColors.surface;
  Color get bgSurfaceVariant => isDarkMode ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant;
  Color get bgSurfaceHover => isDarkMode ? AppColors.darkSurfaceHover : AppColors.surfaceHover;
  Color get bgBackground => isDarkMode ? AppColors.darkBackground : AppColors.background;
  
  Color get dividerColor => isDarkMode ? AppColors.darkDivider : AppColors.divider;
}
