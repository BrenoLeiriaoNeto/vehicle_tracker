import 'package:flutter/material.dart';

class VehicleTrackerApp extends StatelessWidget {
  const VehicleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color(0xFF1E1E2C),
          brightness: .dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.directions_car_filled,
                size: 64,
                color: Colors.greenAccent,
              ),
              SizedBox(height: 16),
              Text(
                "Vehicle Tracker 🏎️",
                style: TextStyle(fontSize: 24, fontWeight: .bold),
              ),
              SizedBox(height: 8),
              Text(
                "Motor do Firebase roncando!",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
