import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/core/theme/theme_controller.dart';

void main() {
  late ThemeController controller;

  setUp(() {
    controller = ThemeController();
  });

  test('initial state is dark theme', () {
    expect(controller.state, ThemeMode.dark);
    expect(controller.isDarkMode, isTrue);
  });

  test('toggleTheme switches between dark and light modes', () {
    controller.toggleTheme();

    expect(controller.state, ThemeMode.light);
    expect(controller.isDarkMode, isFalse);

    controller.toggleTheme();

    expect(controller.state, ThemeMode.dark);
    expect(controller.isDarkMode, isTrue);
  });
}
