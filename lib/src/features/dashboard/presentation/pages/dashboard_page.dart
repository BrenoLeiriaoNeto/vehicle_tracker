import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/state/auth_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rastreador de veículos'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Painel de controle 📊',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('O coração do vehicle tracker acordou'),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                final authController =
                    IonProvider.of<AuthState>(context) as AuthController;
                authController.logout();
              },
              label: const Text('Sair'),
              icon: const Icon(Icons.logout),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
