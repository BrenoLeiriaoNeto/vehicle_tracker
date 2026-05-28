import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

abstract class IGarageRepository {
  Future<List<BrandEntity>> getBrands();
}
