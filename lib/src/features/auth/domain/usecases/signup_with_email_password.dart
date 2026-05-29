import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class SignupWithEmailPassword {
  final IAuthRepository _repository;

  SignupWithEmailPassword(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _repository.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}
