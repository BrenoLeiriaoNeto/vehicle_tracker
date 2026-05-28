import 'package:vehicle_tracker/src/features/garage/data_exports.dart';

abstract class IFipeDataSource {
  Future<List<BrandModel>> getBrands();
}
