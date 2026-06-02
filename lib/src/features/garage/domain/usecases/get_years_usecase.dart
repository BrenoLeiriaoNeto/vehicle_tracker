import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GetYearsUseCase {
  final IVehicleRepository _repository;

  GetYearsUseCase(this._repository);
  Future<List<FipeItem>> call(String brandId, String modelId) =>
      _repository.getYears(brandId, modelId);
}
