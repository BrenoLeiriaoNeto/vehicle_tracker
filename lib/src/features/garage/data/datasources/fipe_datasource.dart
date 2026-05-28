import 'package:dio/dio.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';

class FipeDataSource implements IFipeDataSource {
  final HttpClient _httpClient;

  FipeDataSource(this._httpClient);

  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await _httpClient.dio.get('/carros/marcas.json');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> list = response.data;

        return list.map((item) => BrandModel.fromJson(item)).toList();
      }

      throw Exception('Falha ao carregar as marcas da FIPE');
    } on DioException catch (e) {
      throw Exception('Erro de rede na API da FIPE: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado no Datasource: $e');
    }
  }
}
