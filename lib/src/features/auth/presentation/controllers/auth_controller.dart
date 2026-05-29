import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/auth_state.dart';

class AuthController extends Ion<AuthState> {
  final LoginWithEmailPasswordUsecase _loginUseCase;

  AuthController(this._loginUseCase) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    if (state.status == .loading) return;

    set(state.copyWith(status: .loading));

    try {
      final userCredential = await _loginUseCase(
        email: email,
        password: password,
      );

      set(
        state.copyWith(
          status: .authenticated,
          user: userCredential,
          errorMessage: null,
        ),
      );
    } on AuthFailure catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.message));
    } catch (_) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Ocorreu um erro inesperado ao tentar logar.',
        ),
      );
    }
  }

  void setAuthenticatedUser(UserEntity user) {
    set(state.copyWith(status: .authenticated, user: user));
  }

  void logout() {
    set(AuthState(status: .unauthenticated));
  }
}
