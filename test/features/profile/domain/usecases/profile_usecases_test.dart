import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class MockIProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late MockIProfileRepository repository;

  setUp(() {
    repository = MockIProfileRepository();
  });

  group('GetProfileUsecase', () {
    test('deve delegar a busca de perfil ao repositório', () async {
      final usecase = GetProfileUsecase(repository);
      final profile = Profile(
        avatarUrl: 'https://image.url/avatar.png',
        bio: 'Bio',
        tripsCompleted: 1,
        sumKilometers: 10.0,
        totalVehicles: 1,
        memberSince: DateTime(2022, 1, 1),
      );

      when(
        () => repository.getProfile('user123'),
      ).thenAnswer((_) async => profile);

      final result = await usecase.call('user123');

      expect(result, profile);
    });
  });

  group('UpdateProfileUsecase', () {
    test('deve delegar a atualização ao repositório', () async {
      final usecase = UpdateProfileUsecase(repository);
      final profile = Profile(
        avatarUrl: 'https://image.url/avatar.png',
        bio: 'Bio atualizada',
        tripsCompleted: 2,
        sumKilometers: 20.0,
        totalVehicles: 1,
        memberSince: DateTime(2022, 1, 1),
      );

      when(
        () => repository.updateProfile('user123', profile),
      ).thenAnswer((_) async => profile);

      final result = await usecase.call('user123', profile);

      expect(result, profile);
    });
  });

  group('DeleteProfileUsecase', () {
    test('deve delegar a exclusão de perfil ao repositório', () async {
      final usecase = DeleteProfileUsecase(repository);

      when(() => repository.deleteProfile('user123')).thenAnswer((_) async {});

      await usecase.call('user123');

      verify(() => repository.deleteProfile('user123')).called(1);
    });
  });
}
