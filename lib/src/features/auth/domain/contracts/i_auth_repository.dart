import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

abstract class IAuthRepository {
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser(String id);
}
