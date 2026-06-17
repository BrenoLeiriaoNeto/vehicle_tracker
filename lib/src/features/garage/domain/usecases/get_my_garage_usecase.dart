import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GetMyGarageUsecase {
  final IVehicleRepository _repository;

  GetMyGarageUsecase(this._repository);
  Future<List<Vehicle>> call() => _repository.getMyGarage();
}
