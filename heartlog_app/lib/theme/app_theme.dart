import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkGreen,
        secondary: AppColors.sage,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkText,
        onSurface: AppColors.darkText,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: AppColors.darkText,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: AppColors.darkText,
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: AppColors.darkText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.nunito(
          color: AppColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: AppColors.darkText,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: AppColors.mutedText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.nunito(
          color: AppColors.darkText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.darkGreen,
        unselectedItemColor: AppColors.mutedText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          side: const BorderSide(color: AppColors.sage, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.sage, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
