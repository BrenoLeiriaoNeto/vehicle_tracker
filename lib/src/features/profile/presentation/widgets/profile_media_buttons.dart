import 'package:flutter/material.dart';

class ProfileMediaButtons extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ProfileMediaButtons({
    super.key,
    required this.isDisabled,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isDisabled ? null : onCameraPressed,
            label: const Text('Câmera'),
            icon: const Icon(Icons.photo_camera, size: 18),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isDisabled ? null : onGalleryPressed,
            label: const Text('Galeria'),
            icon: const Icon(Icons.photo_library, size: 18),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
