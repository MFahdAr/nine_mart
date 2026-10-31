import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF6FA9C7);
  static const Color deepBlue = Color(0xFF306399);
  static const Color mintIce = Color(0xFFC9E2DE);
  static const Color creamBackground = Color(0xFFF5F2E8);
  static const Color darkText = Color(0xFF2C3E50);
  static const Color greyText = Color(0xFF7F8C8D);
  static const Color starGold = Color(0xFFFFC107);
  static const Color cardWhite = Colors.white;
}

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.creamBackground,
      primaryColor: AppColors.deepBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.deepBlue,
        primary: AppColors.deepBlue,
        secondary: AppColors.primaryBlue,
        surface: AppColors.creamBackground,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.deepBlue),
        titleTextStyle: GoogleFonts.epilogue(
          color: AppColors.deepBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
