import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class DeleteProfileUsecase {
  final IProfileRepository _repository;

  DeleteProfileUsecase(this._repository);

  Future<void> call(String id) => _repository.deleteProfile(id);
}
