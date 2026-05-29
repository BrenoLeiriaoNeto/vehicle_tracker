import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

abstract class IAuthRepository {
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();
}
