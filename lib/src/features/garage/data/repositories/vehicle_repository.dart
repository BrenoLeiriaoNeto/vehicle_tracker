import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/garage/domain/contracts/i_vehicle_repository.dart';
import 'package:vehicle_tracker/src/features/garage/domain/entities/fipe_item.dart';
import 'package:vehicle_tracker/src/features/garage/domain/entities/vehicle.dart';
import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';

class VehicleRepository implements IVehicleRepository {
  final HttpClient _httpClient;
  final FirebaseFirestore _firestore;

  VehicleRepository(this._httpClient, this._firestore);

  @override
  Future<List<FipeItem>> getBrands() async {
    final response = await _httpClient.dio.get('/cars/brands');
    return (response.data as List)
        .map((e) => FipeItemModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<FipeItem>> getModels(String brandId) async {
    final response = await _httpClient.dio.get('/cars/brands/$brandId/models');
    return (response.data as List)
        .map((e) => FipeItemModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<Vehicle>> getMyGarage() async {
    final snapshot = await _firestore.collection('garage').get();
    return snapshot.docs
        .map((doc) => VehicleModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<FipeItem>> getYears(String brandId, String modelId) async {
    final response = await _httpClient.dio.get(
      '/cars/brands/$brandId/models/$modelId/years',
    );
    return (response.data as List)
        .map((e) => FipeItemModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> saveVehicle(Vehicle vehicle) async {
    final model = VehicleModel(
      plate: vehicle.plate,
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      currentKm: vehicle.currentKm,
      status: vehicle.status,
    );

    await _firestore
        .collection('garage')
        .doc(model.plate.toUpperCase())
        .set(model.toMap());
  }
}
