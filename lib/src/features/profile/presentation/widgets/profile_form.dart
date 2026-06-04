import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';

class ProfileForm extends StatefulWidget {
  final String userId;
  final ProfileController profileController;

  const ProfileForm({
    required this.userId,
    required this.profileController,
    super.key,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bioController;
  late final TextEditingController _avatarController;

  bool _isSaving = false;
  bool _isUploadingImage = false;
  bool _imageFromDevice = false;

  @override
  void initState() {
    super.initState();
    final currentProfile = widget.profileController.state.profile;

    _bioController = TextEditingController(text: currentProfile?.bio ?? '');
    _avatarController = TextEditingController(
      text: currentProfile?.avatarUrl ?? '',
    );

    _avatarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() => _isUploadingImage = true);

    try {
      final storageService = sl<CloudflareStorageService>();
      final file = File(pickedFile.path);
      final uploadedUrl = await storageService.uploadAvatar(file);

      if (uploadedUrl != null) {
        setState(() {
          _avatarController.text = uploadedUrl;
          _imageFromDevice = true;
        });
        _showSnackBar('imagem carregada com sucesso!');
      }
    } catch (e) {
      _showSnackBar('Erro ao fazer upload da imagem.');
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await widget.profileController.updateBioProfile(
        widget.userId,
        _bioController.text.trim(),
        _avatarController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        _showSnackBar('Perfil atualizado!');
      }
    } catch (e) {
      setState(() => _isSaving = false);
    }
  }

  String? _validateAvatarUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'Insira uma URL válida';
    }

    final lowerCaseUrl = value.toLowerCase();
    final hasValidExtension =
        lowerCaseUrl.endsWith('.jpg') ||
        lowerCaseUrl.endsWith('.jpeg') ||
        lowerCaseUrl.endsWith('.png') ||
        lowerCaseUrl.endsWith('.svg');

    if (!hasValidExtension) {
      return 'A URL deve terminar em .jpg, .jpeg, .png ou .svg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Text(
                'Editar Perfil',
                style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
                textAlign: .center,
              ),
              const SizedBox(height: 24),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage:
                          _avatarController.text.trim().isNotEmpty &&
                              _validateAvatarUrl(_avatarController.text) == null
                          ? NetworkImage(_avatarController.text.trim())
                          : null,
                      child:
                          _avatarController.text.trim().isEmpty ||
                              _validateAvatarUrl(_avatarController.text) != null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: colorScheme.onPrimaryContainer,
                            )
                          : null,
                    ),
                    if (_isUploadingImage)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: .circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Formatos suportados: JPG, JPEG, PNG e SVG',
                style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
                textAlign: .center,
              ),

              const SizedBox(height: 24),

              CustomTextFormField(
                controller: _bioController,
                labelText: 'Biografia',
                prefixIcon: Icons.description,
                textInputAction: .next,
                keyboardType: .text,
                maxLines: 3,
                maxLength: 120,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: _avatarController,
                labelText: _imageFromDevice
                    ? 'URL da imagem (dispositivo)'
                    : 'URL da imagem de perfil',
                prefixIcon: _imageFromDevice ? Icons.cloud_done : Icons.link,
                keyboardType: .url,
                validator: _validateAvatarUrl,
                suffixIcon: _avatarController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _avatarController.clear();
                          setState(() => _imageFromDevice = false);
                        },
                      )
                    : null,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isUploadingImage || _isSaving
                          ? null
                          : () => _pickAndUploadImage(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera, size: 18),
                      label: const Text('Câmera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isUploadingImage || _isSaving
                          ? null
                          : () => _pickAndUploadImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library, size: 18),
                      label: const Text('Galeria'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSaving || _isUploadingImage ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Salvar Alterações',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
