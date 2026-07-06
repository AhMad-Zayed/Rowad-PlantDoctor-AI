import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D631B);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color primaryContainerColor = Color(0xFF2E7D32);
  static const Color onPrimaryContainerColor = Color(0xFFCBFFC2);
  static const Color secondaryColor = Color(0xFF3C6842);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color secondaryContainerColor = Color(0xFFBDEFBE);
  static const Color onSecondaryContainerColor = Color(0xFF426E47);
  static const Color backgroundColor = Color(0xFFFDF8FD);
  static const Color onBackgroundColor = Color(0xFF1C1B1F);
  static const Color surfaceColor = Color(0xFFFDF8FD);
  static const Color onSurfaceColor = Color(0xFF1C1B1F);
  static const Color surfaceVariantColor = Color(0xFFE5E1E7);
  static const Color onSurfaceVariantColor = Color(0xFF40493D);
  static const Color outlineColor = Color(0xFF707A6C);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color errorContainerColor = Color(0xFFFFDAD6);
  static const Color onErrorContainerColor = Color(0xFF93000A);
  
  // Custom containers matching Stitch surface hierarchy
  static const Color surfaceContainerLow = Color(0xFFF7F2F8);
  static const Color surfaceContainer = Color(0xFFF1ECF2);
  static const Color surfaceContainerHigh = Color(0xFFEBE7EC);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryContainerColor,
        onPrimaryContainer: onPrimaryContainerColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
        secondaryContainer: secondaryContainerColor,
        onSecondaryContainer: onSecondaryContainerColor,
        background: backgroundColor,
        onBackground: onBackgroundColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceVariant: surfaceVariantColor,
        onSurfaceVariant: onSurfaceVariantColor,
        outline: outlineColor,
        error: errorColor,
        onError: Colors.white,
        errorContainer: errorContainerColor,
        onErrorContainer: onErrorContainerColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
          headlineLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
          titleLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          bodyMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}
