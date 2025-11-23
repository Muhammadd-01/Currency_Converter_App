import 'package:flutter/material.dart';

class AppTheme {
  // Gradient Colors
  static const primaryGradientStart = Color(0xFF4A00E0);
  static const primaryGradientEnd = Color(0xFF8E2DE2);

  static const secondaryGradientStart = Color(0xFF0F2027);
  static const secondaryGradientMid = Color(0xFF203A43);
  static const secondaryGradientEnd = Color(0xFF2C5364);

  // Additional Colors
  static const accentColor = Color(0xFF00D4FF);
  static const successColor = Color(0xFF00E676);
  static const warningColor = Color(0xFFFFAB00);
  static const errorColor = Color(0xFFFF5252);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [
      secondaryGradientStart,
      secondaryGradientMid,
      secondaryGradientEnd
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0E21),

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryGradientEnd,
      secondary: accentColor,
      surface: Color(0xFF1A1A2E),
      error: errorColor,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A2E).withOpacity(0.5),
      elevation: 8,
      shadowColor: primaryGradientEnd.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A2E).withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: primaryGradientEnd.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primaryGradientEnd,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: errorColor,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.5),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shadowColor: primaryGradientEnd.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.white60,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1A1A2E),
      selectedItemColor: primaryGradientEnd,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      type: BottomNavigationBarType.fixed,
      elevation: 20,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
    ),
  );
}
