import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class SignupState {
  final SignupStatus status;
  final String? errorMessage;
  final dynamic createdUser;

  const SignupState({
    required this.status,
    this.errorMessage,
    this.createdUser,
  });

  factory SignupState.initial() => const SignupState(status: .idle);

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    dynamic createdUser,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdUser: createdUser ?? this.createdUser,
    );
  }
}
