import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/theme/app_theme.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/login_page.dart';

class VehicleTrackerApp extends StatelessWidget {
  const VehicleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: LoginPage(),
    );
  }
}
