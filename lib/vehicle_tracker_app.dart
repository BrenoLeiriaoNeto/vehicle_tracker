import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';

class VehicleTrackerApp extends StatelessWidget {
  const VehicleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return IonBuilder<ThemeMode>(
      ion: sl<ThemeController>(),
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Vehicle Tracker',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
