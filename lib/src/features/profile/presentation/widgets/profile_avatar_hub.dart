import 'package:flutter/material.dart';

class ProfileAvatarHub extends StatelessWidget {
  final String avatarUrl;
  final bool isUploading;
  final bool hasValidUrl;

  const ProfileAvatarHub({
    super.key,
    required this.avatarUrl,
    required this.isUploading,
    required this.hasValidUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: .min,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: avatarUrl.isNotEmpty && hasValidUrl
                    ? NetworkImage(avatarUrl)
                    : null,
                onBackgroundImageError: avatarUrl.isNotEmpty && hasValidUrl
                    ? (exception, stackTrace) {
                        debugPrint(
                          'Erro ao carregar imagem do perfil: $exception',
                        );
                      }
                    : null,
                child: avatarUrl.isEmpty || !hasValidUrl
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: .circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Formato suportados: JPG, JPEG, PNG e SVG',
          style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
          textAlign: .center,
        ),
      ],
    );
  }
}
