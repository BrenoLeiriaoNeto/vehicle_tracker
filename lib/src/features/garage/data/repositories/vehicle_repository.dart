import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
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
    try {
      final response = await _httpClient.dio.get('/cars/brands');
      return (response.data as List)
          .map((e) => FipeItemModel.fromJson(e))
          .toList();
    } on DioException catch (_) {
      throw const FipeNetworkFailure();
    } catch (_) {
      throw const FipeDataParsingFailure();
    }
  }

  @override
  Future<List<FipeItem>> getModels(String brandId) async {
    try {
      final response = await _httpClient.dio.get(
        '/cars/brands/$brandId/models',
      );
      return (response.data as List)
          .map((e) => FipeItemModel.fromJson(e))
          .toList();
    } on DioException catch (_) {
      throw const FipeNetworkFailure();
    } catch (_) {
      throw const FipeDataParsingFailure();
    }
  }

  @override
  Future<List<Vehicle>> getMyGarage() async {
    try {
      final snapshot = await _firestore.collection('garage').get();
      return snapshot.docs
          .map((doc) => VehicleModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (_) {
      throw const GarageStorageFailure('Erro ao ler a lista de veículos.');
    } catch (_) {
      throw const UnknownGarageFailure();
    }
  }

  @override
  Future<List<FipeItem>> getYears(String brandId, String modelId) async {
    try {
      final response = await _httpClient.dio.get(
        '/cars/brands/$brandId/models/$modelId/years',
      );
      return (response.data as List)
          .map((e) => FipeItemModel.fromJson(e))
          .toList();
    } on DioException catch (_) {
      throw const FipeNetworkFailure();
    } catch (_) {
      throw const FipeDataParsingFailure();
    }
  }

  @override
  Future<void> saveVehicle(Vehicle vehicle) async {
    try {
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
    } on FirebaseException catch (_) {
      throw const GarageStorageFailure(
        'Erro ao salvar o veículo no servidor em nuvem.',
      );
    } catch (e) {
      throw UnknownGarageFailure('Erro inesperado ao salvar: $e');
    }
  }

  @override
  Future<void> updateVehicleMileageAfterTrip(
    String vehicleId,
    double kmsDriven,
  ) async {
    try {
      await _firestore.collection('garage').doc(vehicleId).update({
        'currentKm': FieldValue.increment(kmsDriven),
      });
    } on FirebaseException catch (_) {
      throw const GarageStorageFailure('Erro ao atualizar a kilometragem!');
    } catch (e) {
      throw UnknownGarageFailure(
        'Erro inesperado ao tentar atualizar os kms: $e',
      );
    }
  }
}
