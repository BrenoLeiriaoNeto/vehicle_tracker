import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/state/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final authController = IonProvider.of<AuthController>(context);
    final profileController = IonProvider.of<ProfileController>(context);

    final userUid = authController.state.user?.id;

    if (userUid != null && profileController.state.status == .initial) {
      Future.microtask(() => profileController.loadProfile(userUid));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();

              context.go('/logout');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IonConsumer<ProfileController, ProfileState>(
        builder: (context, state, controller) {
          if (state.status == .loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == .error) {
            return Center(
              child: Text('Erro ao carregar perfil: ${state.errorMessage}'),
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('Perfil não encontrado.'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? NetworkImage(profile.avatarUrl!)
                      : const AssetImage('assets/images/CP avatar.jpg')
                            as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  authController.state.user?.name ?? 'Usuário',
                  style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
                ),
                Text(
                  profile.bio ?? 'Nenhuma bio definida ainda.',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () => context.go('/profile/edit'),
                  label: const Text('Editar Perfil'),
                  icon: Icon(Icons.edit),
                ),

                const Divider(height: 40),

                Row(
                  children: [
                    _buildMetricsCard(
                      context,
                      'Carros',
                      '${profile.totalVehicles}',
                    ),
                    _buildMetricsCard(
                      context,
                      'Viagens',
                      '${profile.tripsCompleted}',
                    ),
                    _buildMetricsCard(
                      context,
                      'Km Rodados',
                      profile.sumKilometers.toStringAsFixed(0),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: .bold),
              ),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
