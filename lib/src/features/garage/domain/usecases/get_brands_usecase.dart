import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class GetBrandsUseCase {
  final IGarageRepository _repository;

  GetBrandsUseCase(this._repository);

  Future<List<BrandEntity>> call() async {
    try {
      final brands = await _repository.getBrands();

      brands.sort((a, b) => a.name.compareTo(b.name));

      return brands;
    } catch (e) {
      throw Exception('Falha no caso de uso ao processar marcas: $e');
    }
  }
}
