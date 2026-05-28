import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();
}
