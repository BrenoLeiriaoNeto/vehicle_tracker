import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.initial() => const AuthState(status: .idle);

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
