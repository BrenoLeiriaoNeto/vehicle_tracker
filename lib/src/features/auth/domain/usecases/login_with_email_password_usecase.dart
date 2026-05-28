import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class LoginWithEmailPasswordUsecase {
  final IAuthRepository _repository;

  LoginWithEmailPasswordUsecase(this._repository);

  Future<UserCredential> call({
    required String email,
    required String password,
  }) async {
    return await _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
