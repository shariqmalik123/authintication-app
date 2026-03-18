import 'app_colors.dart';
import 'app_text_style.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.transparent,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.lightSurface,
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headingLarge.copyWith(
        color: AppColors.lightText,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightText),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.lightSubText,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightText,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.transparent,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.darkSurface,
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headingLarge.copyWith(
        color: AppColors.darkText,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkSubText),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkText,
      elevation: 0,
    ),
  );
}
