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
        surface: Color(0xFF1E1E22),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1e1e22),
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
}
