import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

abstract class IVehicleRepository {
  Future<List<FipeItem>> getBrands();
  Future<List<FipeItem>> getModels(String brandId);
  Future<List<FipeItem>> getYears(String brandId, String modelId);

  Future<void> saveVehicle(Vehicle vehicle);
  Future<List<Vehicle>> getMyGarage();
}
