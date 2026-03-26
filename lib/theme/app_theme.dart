import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.accent,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.accentBright,
      onSecondary: AppColors.textPrimary,
      error: AppColors.danger,
      onError: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceElevated,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.accentBright,
      tertiary: AppColors.success,
      onTertiary: AppColors.background,
    );

    final textTheme =
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            height: 0.94,
            letterSpacing: -1.8,
          ),
          displayMedium: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -1.2,
          ),
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -0.7,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -0.4,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: AppColors.outline.withValues(alpha: 0.5),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    );
  }
}
