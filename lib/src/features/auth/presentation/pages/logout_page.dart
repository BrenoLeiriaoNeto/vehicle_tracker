import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _executeFullTeardown();
    });
  }

  Future<void> _executeFullTeardown() async {
    debugPrint('[TEARDOWN]: INICIANDO TEARDOWN COM DELAY DE 300 MILIS');
    await Future.delayed(const Duration(milliseconds: 600));

    final authController = sl<AuthController>();
    final tripController = sl<TripController>();
    debugPrint('[TEARDOWN]: CONTROLLERS INSTANCIADOS, SEGUINDO PRO TRY-CATCH');

    try {
      debugPrint('[TEARDOWN]: INICIANDO LOGOUTCLEAR()');
      await tripController.logoutClear();

      debugPrint(
        '[TEARDOWN]: LOGOUTCLEAR() EXECUTADO, AGORA MAIS UM DELAY DE 800 MILIS',
      );
      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('[TEARDOWN]: DELAY TERMINADO, EXECUTANDO LOGOUT()');
      await authController.logout();

      debugPrint(
        '[TEARDOWN]: LOGOUT() EXECUTADO, INICIANDO DELAY DE 200 MILIS',
      );
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('Erro durante o teardown de segurança: $e');
    } finally {
      debugPrint('[TEARDOWN]: CHEGOU NO FINALLY, FAZENDO SETUNAUTH');
      authController.setUnauthenticatedUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'Encerrando sessão com segurança...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: .w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
