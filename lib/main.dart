import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart' as di;
import 'package:vehicle_tracker/src/core/services/firebase_options.dart';
import 'package:vehicle_tracker/vehicle_tracker_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("🔥 [Firebase] Inicializado com sucesso absoluto!");
  } catch (e) {
    debugPrint("❌ [Firebase] Erro ao inicializar: $e");
  }

  await di.initDependencies();

  runApp(const VehicleTrackerApp());
}
