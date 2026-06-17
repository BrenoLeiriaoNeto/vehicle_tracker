import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

class ThemeController extends Ion<ThemeMode> {
  ThemeController() : super(ThemeMode.dark);

  void toggleTheme() {
    if (state == .dark) {
      set(.light);
    } else {
      set(.dark);
    }
  }

  bool get isDarkMode => state == .dark;
}
