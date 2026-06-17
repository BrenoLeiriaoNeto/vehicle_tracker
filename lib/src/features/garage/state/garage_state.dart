import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GarageState {
  final GarageStatus status;
  final List<Vehicle> vehicles;
  final List<Vehicle> filteredVehicles;
  final String? errorMessage;

  GarageState({
    required this.status,
    required this.vehicles,
    required this.filteredVehicles,
    this.errorMessage,
  });

  factory GarageState.initial() =>
      GarageState(status: .initial, vehicles: [], filteredVehicles: []);

  GarageState copyWith({
    GarageStatus? status,
    List<Vehicle>? vehicles,
    List<Vehicle>? filteredVehicles,
    String? errorMessage,
  }) {
    return GarageState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
