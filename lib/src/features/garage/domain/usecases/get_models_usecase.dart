import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GetModelsUseCase {
  final IVehicleRepository _repository;

  GetModelsUseCase(this._repository);
  Future<List<FipeItem>> call(String brandId) => _repository.getModels(brandId);
}
