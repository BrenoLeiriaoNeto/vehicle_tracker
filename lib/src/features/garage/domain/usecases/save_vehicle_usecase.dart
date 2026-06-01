import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class SaveVehicleUseCase {
  final IVehicleRepository _repository;

  SaveVehicleUseCase(this._repository);
  Future<void> call(Vehicle vehicle) => _repository.saveVehicle(vehicle);
}
