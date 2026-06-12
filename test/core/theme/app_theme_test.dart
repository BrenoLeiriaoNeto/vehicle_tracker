import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/core/theme/app_theme.dart';

void main() {
  test('darkTheme returns correct color scheme and brightness', () {
    final theme = AppTheme.darkTheme;

    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, const Color(0xFF00B4D8));
    expect(theme.colorScheme.surface, const Color(0xFF1E1E22));
    expect(theme.inputDecorationTheme.filled, isTrue);
  });

  test('lightTheme returns correct color scheme and brightness', () {
    final theme = AppTheme.lightTheme;

    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, const Color(0xFF00B4D8));
    expect(theme.colorScheme.surface, Colors.white);
    expect(theme.inputDecorationTheme.filled, isTrue);
  });
}
