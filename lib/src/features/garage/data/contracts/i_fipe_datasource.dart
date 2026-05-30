import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';

abstract class IFipeDataSource {
  Future<List<BrandModel>> getBrands();
}
