import 'package:flutter/material.dart';

class AppTheme {
  // Ultra-Dark Premium Palette (inspired by daily.dev)
  static const backgroundColor = Color(0xFF0B0E14); // Near black
  static const surfaceColor = Color(0xFF151921); // Card background
  static const primaryColor = Color(0xFF6366F1); // Brand Indigo
  static const secondaryColor = Color(0xFF10B981); // Emerald
  static const textColor = Color(0xFFE2E8F0); // Off-white text
  static const textSecondaryColor = Color(0xFF94A3B8); // Muted text
  static const accentColor = Color(0xFFF43F5E); // Rose
  static const dividerColor = Color(0xFF1E293B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: textColor,
        background: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}
