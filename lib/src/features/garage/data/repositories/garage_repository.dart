import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GarageRepository implements IGarageRepository {
  final IFipeDataSource _dataSource;

  GarageRepository(this._dataSource);

  @override
  Future<List<BrandEntity>> getBrands() async {
    try {
      final brandModels = await _dataSource.getBrands();

      return brandModels.map((models) => models as BrandEntity).toList();
    } catch (e) {
      throw Exception('Erro no GarageRepository ao buscar marcas: $e');
    }
  }
}
