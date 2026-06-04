import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

abstract class IProfileRepository {
  Future<Profile> getProfile(String id);
  Future<Profile> updateProfile(String id, Profile profile);
  Future<void> deleteProfile(String id);
}
