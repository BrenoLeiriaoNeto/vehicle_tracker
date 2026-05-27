import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';

class GaragePage extends StatefulWidget {
  final GarageController controller;
  const GaragePage({super.key, required this.controller});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
