import 'package:vehicle_tracker/src/features/garage/domain_exports.dart';

abstract class IGarageRepository {
  Future<List<BrandEntity>> getBrands();
}
