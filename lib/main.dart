import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/vehicle_tracker_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initDependencies();

  runApp(const VehicleTrackerApp());
}
