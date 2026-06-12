import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class LogoutUsecase {
  final IAuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<void> call() async => await _repository.logout();
}
