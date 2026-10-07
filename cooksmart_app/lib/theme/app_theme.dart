import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F1115);
  static const Color surfaceLowest = Color(0xFF0C0E12);
  static const Color surfaceLow = Color(0xFF181B22);
  static const Color surfaceElevated = Color(0xFF222733);
  static const Color surfaceHigh = Color(0xFF282D3B);
  
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryAmber = Color(0xFFFFA630);
  
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textDim = Color(0xFF64748B);
  
  static const Color border = Color(0xFF272E3D);
  static const Color success = Color(0xFF10B981);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOrange,
        secondary: AppColors.secondaryAmber,
        surface: AppColors.surfaceLow,
        onSurface: AppColors.textWhite,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.epilogue(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.epilogue(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        headlineSmall: GoogleFonts.epilogue(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textWhite,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textWhite,
          fontSize: 14,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
