import 'package:flutter/material.dart';

class AppTheme {
  // Nidaamka midabada: Premium Light Mode (Slate & Indigo)
  
  static const backgroundColor = Color(0xFFF8FAFC); // Midabka asalka ah (Slate 50)
  static const surfaceColor = Color(0xFFFFFFFF);    // Midabka kaararka (White)
  static const primaryColor = Color(0xFF6366F1);    // Midabka koowaad (Indigo)
  static const secondaryColor = Color(0xFF6366F1);  // Midabka labaad
  static const textColor = Color(0xFF0F172A);       // Midabka qoraalka (Slate 900)
  static const textSecondaryColor = Color(0xFF64748B); // Qoraalka labaad (Slate 500)
  static const dividerColor = Color(0xFFE2E8F0);    // Midabka xariiqyada (Slate 200)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: textColor,
        background: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 1),
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

  // Waxaan haynaa darkTheme laakiin hadda waxaan u bedelnay light
  static ThemeData get darkTheme => lightTheme; 
}

