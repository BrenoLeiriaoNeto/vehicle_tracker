import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';

class VehicleTrackerApp extends StatelessWidget {
  const VehicleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vehicle Tracker',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router,
      theme: AppTheme.darkTheme,
    );
  }
}
