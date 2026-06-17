import 'package:flutter/material.dart';

class NewTripActionButtons extends StatelessWidget {
  final bool isLandscape;
  final bool isSubmitting;
  final VoidCallback? onSavePressed;
  final VoidCallback? onStartPressed;

  const NewTripActionButtons({
    super.key,
    required this.isLandscape,
    required this.isSubmitting,
    this.onSavePressed,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isSubmitting) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final startButton = ElevatedButton.icon(
      onPressed: onStartPressed,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Criar e iniciar viagem'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
      ),
    );

    final saveButton = OutlinedButton.icon(
      onPressed: onSavePressed,
      label: const Text('Criar Viagem'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );

    if (isLandscape) {
      return Row(
        children: [
          Expanded(child: saveButton),
          const SizedBox(width: 16),
          Expanded(child: startButton),
        ],
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [startButton, const SizedBox(height: 12), saveButton],
    );
  }
}
