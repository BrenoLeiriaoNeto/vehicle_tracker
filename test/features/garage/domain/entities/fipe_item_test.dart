import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

void main() {
  group('FipeItem', () {
    test('deve criar um FipeItem com valores corretos', () {
      const item = FipeItem(codigo: '123', nome: 'Palio');

      expect(item.codigo, '123');
      expect(item.nome, 'Palio');
    });
  });
}
