import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: .dark,
      scaffoldBackgroundColor: const Color(0xFF121214),
      colorScheme: const .dark(
        primary: Color(0xFF00B4D8),
        secondary: Color(0xFF06D6A0),
        tertiary: Colors.white38,
        surface: Color(0xFF1E1E22),
      ),

      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontWeight: .bold),
        titleMedium: TextStyle(color: Colors.white, fontWeight: .w600),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white38),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1e1e22),
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: .none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B4D8),
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          textStyle: const TextStyle(fontWeight: .bold, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: .light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00B4D8),
        secondary: Color(0xFF06D6A0),
        tertiary: Colors.black54,
        surface: Color(0xFFFFFFFF),
      ),

      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFF121214), fontWeight: .bold),
        titleMedium: TextStyle(color: Color(0xFF1E1E22), fontWeight: .w600),
        bodyLarge: TextStyle(color: Color(0xFF121214)),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        hintStyle: const TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B4D8),
          foregroundColor: Colors.white,
          minimumSize: const .fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          textStyle: const TextStyle(fontWeight: .bold, fontSize: 16),
        ),
      ),
    );
  }
}
