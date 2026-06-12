import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/auth/auth_data_exports.dart';

void main() {
  group('UserModel', () {
    test('fromJson deve criar um UserModel com os valores corretos', () {
      final user = UserModel.fromJson({
        'email': 'test@example.com',
        'name': 'Usuário Teste',
        'role': 'driver',
      }, 'abc123');

      expect(user.id, 'abc123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Usuário Teste');
      expect(user.role, 'driver');
    });

    test('toJson deve retornar um mapa sem o id', () {
      final model = UserModel(
        id: 'abc123',
        email: 'test@example.com',
        name: 'Usuário Teste',
        role: 'driver',
      );

      expect(model.toJson(), {
        'email': 'test@example.com',
        'name': 'Usuário Teste',
        'role': 'driver',
      });
    });
  });
}
