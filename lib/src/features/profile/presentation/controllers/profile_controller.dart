import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/state/profile_state.dart';

class ProfileController extends Ion<ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final DeleteProfileUsecase _deleteProfileUsecase;

  ProfileController(
    this._getProfileUsecase,
    this._updateProfileUsecase,
    this._deleteProfileUsecase,
  ) : super(const ProfileState());

  Future<void> loadProfile(String userId) async {
    set(state.copyWith(status: .loading));

    try {
      final profileData = await _getProfileUsecase(userId);

      set(state.copyWith(status: .success, profile: profileData));
    } catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.toString()));
    }
  }

  Future<void> updateBioProfile(
    String userId,
    String? newBio,
    String? newAvatar,
  ) async {
    final currentProfile = state.profile;
    if (currentProfile == null) return;

    final updateProfile = Profile(
      avatarUrl: (newAvatar != null && newAvatar.isNotEmpty)
          ? newAvatar
          : currentProfile.avatarUrl,
      bio: (newBio != null && newBio.isNotEmpty) ? newBio : currentProfile.bio,
      tripsCompleted: currentProfile.tripsCompleted,
      sumKilometers: currentProfile.sumKilometers,
      totalVehicles: currentProfile.totalVehicles,
      memberSince: currentProfile.memberSince,
    );

    try {
      await _updateProfileUsecase(userId, updateProfile);

      set(state.copyWith(status: .success, profile: updateProfile));
    } catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.toString()));
    }
  }

  Future<void> deleteProfile(String userId) async {
    set(state.copyWith(status: .loading));

    try {
      await _deleteProfileUsecase(userId);

      set(state.copyWith(status: .success));
    } catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.toString()));
    }
  }
}
