import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class GetProfileUsecase {
  final IProfileRepository _repository;
  GetProfileUsecase(this._repository);

  Future<Profile> call(String id) => _repository.getProfile(id);
}
