import 'package:flutter/material.dart';

/// Colours from the Retorna mock-ups.
abstract final class AppColors {
  static const green = Color(0xFF125E4B);
  static const mint = Color(0xFFDDF1E7);
  static const red = Color(0xFFB8402F);
  static const redSoft = Color(0xFFF9E1DC);
  static const background = Color(0xFFF5F7F5);
  static const border = Color(0xFFE2E8E4);
  static const textMuted = Color(0xFF5E6A65);
  static const scannerDark = Color(0xFF1C2622);
  static const scannerDarker = Color(0xFF121916);
  static const scannerAccent = Color(0xFF7ED8B4);
  static const torch = Color(0xFFF5C542);
}

ThemeData buildTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      primary: AppColors.green,
      error: AppColors.red,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  // Built from the theme's typography so buttons keep the app font.
  final buttonText = base.textTheme.labelLarge?.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  return base.copyWith(
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: buttonShape,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: buttonShape,
        side: const BorderSide(color: AppColors.green, width: 1.5),
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: buttonText?.copyWith(fontSize: 16),
      ),
    ),
  );
}
