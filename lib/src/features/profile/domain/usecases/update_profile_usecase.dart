import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class UpdateProfileUsecase {
  final IProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  Future<Profile> call(String id, Profile profile) =>
      _repository.updateProfile(id, profile);
}
