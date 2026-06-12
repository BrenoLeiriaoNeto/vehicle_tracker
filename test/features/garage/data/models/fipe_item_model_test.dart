import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';

void main() {
  group('FipeItemModel', () {
    test('fromJson deve mapear corretamente o JSON para o modelo', () {
      final json = {'code': 42, 'name': 'Gol'};
      final model = FipeItemModel.fromJson(json);

      expect(model.codigo, '42');
      expect(model.nome, 'Gol');
    });
  });
}
