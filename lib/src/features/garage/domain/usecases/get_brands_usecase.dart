import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GetBrandsUseCase {
  final IVehicleRepository _repository;
  GetBrandsUseCase(this._repository);
  Future<List<FipeItem>> call() => _repository.getBrands();
}
