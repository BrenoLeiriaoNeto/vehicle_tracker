import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockDeleteProfileUsecase extends Mock implements DeleteProfileUsecase {}

void main() {
  setUpAll(() {
    registerFallbackValue(Profile());
  });

  late MockGetProfileUsecase getProfileUsecase;
  late MockUpdateProfileUsecase updateProfileUsecase;
  late MockDeleteProfileUsecase deleteProfileUsecase;
  late ProfileController controller;

  setUp(() {
    getProfileUsecase = MockGetProfileUsecase();
    updateProfileUsecase = MockUpdateProfileUsecase();
    deleteProfileUsecase = MockDeleteProfileUsecase();
    controller = ProfileController(
      getProfileUsecase,
      updateProfileUsecase,
      deleteProfileUsecase,
    );
  });

  group('ProfileController', () {
    test('loadProfile deve buscar e atualizar o estado com sucesso', () async {
      final profile = Profile(
        avatarUrl: 'https://image.url/avatar.png',
        bio: 'Bio',
        tripsCompleted: 3,
        sumKilometers: 150.0,
        totalVehicles: 2,
        memberSince: DateTime(2021, 12, 1),
      );

      when(() => getProfileUsecase('user123')).thenAnswer((_) async => profile);

      await controller.loadProfile('user123');

      expect(controller.state.status, ProfileStatus.success);
      expect(controller.state.profile, profile);
    });

    test('updateBioProfile deve atualizar o perfil existente', () async {
      final currentProfile = Profile(
        avatarUrl: 'https://image.url/avatar.png',
        bio: 'Bio',
        tripsCompleted: 3,
        sumKilometers: 150.0,
        totalVehicles: 2,
        memberSince: DateTime(2021, 12, 1),
      );
      controller.set(controller.state.copyWith(profile: currentProfile));

      when(
        () => updateProfileUsecase('user123', any()),
      ).thenAnswer((_) async => currentProfile);

      await controller.updateBioProfile(
        'user123',
        'Bio nova',
        'https://image.url/avatar2.png',
      );

      expect(controller.state.status, ProfileStatus.success);
      expect(controller.state.profile?.bio, 'Bio nova');
      expect(
        controller.state.profile?.avatarUrl,
        'https://image.url/avatar2.png',
      );
    });

    test(
      'deleteProfile deve alterar o estado para success quando removido',
      () async {
        when(() => deleteProfileUsecase('user123')).thenAnswer((_) async {});

        await controller.deleteProfile('user123');

        expect(controller.state.status, ProfileStatus.success);
      },
    );
  });
}
