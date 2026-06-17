import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class ProfileState {
  final ProfileStatus status;
  final Profile? profile;
  final String errorMessage;

  const ProfileState({
    this.status = .initial,
    this.profile,
    this.errorMessage = '',
  });

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
