import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();
    _executeFullTeardown();
  }

  void _executeFullTeardown() {
    final authController = IonProvider.of<AuthController>(context);

    authController.logout();

    authController.setUnauthenticatedUser();
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
