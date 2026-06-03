import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
