import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/widgets/profile_avatar_hub.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/widgets/profile_media_buttons.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bioController;
  late final TextEditingController _avatarController;

  late final ProfileController _profileController;
  late final String _userId;

  bool _isSaving = false;
  bool _isUploadingImage = false;
  bool _imageFromDevice = false;

  @override
  void initState() {
    super.initState();

    _profileController = sl<ProfileController>();

    _userId = sl<AuthController>().state.user?.id ?? '';

    final currentProfile = _profileController.state.profile;

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
      await _profileController.updateBioProfile(
        _userId,
        _bioController.text.trim(),
        _avatarController.text.trim(),
      );

      if (mounted) {
        context.pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil'), centerTitle: true),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == .landscape;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: isLandscape ? _buildLandscapeForm() : _buildPortraitForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileAvatarHub(
          avatarUrl: _avatarController.text.trim(),
          isUploading: _isUploadingImage,
          hasValidUrl: _validateAvatarUrl(_avatarController.text) == null,
        ),
        const SizedBox(height: 24),
        _buildFieldsAndActions(),
      ],
    );
  }

  Widget _buildLandscapeForm() {
    return Row(
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          width: 150,
          child: ProfileAvatarHub(
            avatarUrl: _avatarController.text.trim(),
            isUploading: _isUploadingImage,
            hasValidUrl: _validateAvatarUrl(_avatarController.text) == null,
          ),
        ),

        const SizedBox(width: 32),

        Expanded(
          child: SafeArea(
            top: false,
            bottom: false,
            left: true,
            right: true,
            child: _buildFieldsAndActions(),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsAndActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextFormField(
          controller: _bioController,
          labelText: 'Biografia',
          prefixIcon: Icons.description,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
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
          keyboardType: TextInputType.url,
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
        const SizedBox(height: 16),
        ProfileMediaButtons(
          isDisabled: _isUploadingImage || _isSaving,
          onCameraPressed: () => _pickAndUploadImage(ImageSource.camera),
          onGalleryPressed: () => _pickAndUploadImage(ImageSource.gallery),
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
              : const Text('Salvar Alterações', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
