import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/vehicle_tracker_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initDependencies();

  runApp(
    IonProvider(
      ion: AuthController(sl<LoginWithEmailPasswordUsecase>()),
      child: const VehicleTrackerApp(),
    ),
  );
}
