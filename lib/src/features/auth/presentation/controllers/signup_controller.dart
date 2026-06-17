import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/signup_state.dart';

class SignupController extends Ion<SignupState> {
  final SignupWithEmailPassword _signUpUseCase;

  SignupController(this._signUpUseCase) : super(SignupState.initial());

  Future<void> signUp(String email, String password, String name) async {
    if (state.status == .loading) return;

    set(state.copyWith(status: .loading));

    try {
      final userEntity = await _signUpUseCase(
        email: email,
        password: password,
        name: name,
      );

      set(
        state.copyWith(
          status: .success,
          createdUser: userEntity,
          errorMessage: null,
        ),
      );
    } on AuthFailure catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.message));
    } catch (_) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Ocorreu um erro inesperado ao tentar cadastrar.',
        ),
      );
    }
  }
}
