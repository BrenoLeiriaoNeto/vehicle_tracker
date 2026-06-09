import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/state/profile_state.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = sl<AuthController>();
      final profileController = IonProvider.of<ProfileController>(context);

      if (auth.state.user != null &&
          profileController.state.status == .initial) {
        profileController.loadProfile(auth.state.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final auth = sl<AuthController>();
              final trip = sl<TripController>();

              await trip.logoutClear();

              await auth.logout();

              await Future.delayed(.zero);

              if (mounted) {
                auth.setUnauthenticatedUser();
              }
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

          final userName = sl<AuthController>().state.user?.name ?? 'Usuário';

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? NetworkImage(profile.avatarUrl ?? '')
                      : const AssetImage('assets/images/CP avatar.jpg')
                            as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
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
