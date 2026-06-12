import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/profile/profile_data_exports.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProfileRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = ProfileRepository(firestore);
  });

  group('ProfileRepository', () {
    test('getProfile deve retornar o perfil existente', () async {
      await firestore.collection('users').doc('user123').set({
        'avatarUrl': 'https://image.url/avatar.png',
        'bio': 'Bio',
        'tripsCompleted': 3,
        'sumKilometers': 150.0,
        'totalVehicles': 2,
        'memberSince': Timestamp.fromDate(DateTime(2021, 12, 1)),
      });

      final result = await repository.getProfile('user123');

      expect(result.bio, 'Bio');
      expect(result.tripsCompleted, 3);
      expect(result.sumKilometers, 150.0);
      expect(result.totalVehicles, 2);
    });

    test(
      'updateProfile deve persistir e retornar o modelo atualizado',
      () async {
        final profile = Profile(
          avatarUrl: 'https://image.url/avatar.png',
          bio: 'Bio atualizada',
          tripsCompleted: 4,
          sumKilometers: 200.0,
          totalVehicles: 3,
          memberSince: DateTime(2021, 12, 1),
        );

        final result = await repository.updateProfile('user123', profile);
        final saved = await firestore.collection('users').doc('user123').get();

        expect(result.bio, 'Bio atualizada');
        expect(saved.exists, isTrue);
        expect(saved.data()!['bio'], 'Bio atualizada');
      },
    );

    test('deleteProfile deve remover o documento do Firestore', () async {
      await firestore.collection('users').doc('user123').set({'bio': 'Teste'});

      await repository.deleteProfile('user123');
      final snapshot = await firestore.collection('users').doc('user123').get();

      expect(snapshot.exists, isFalse);
    });

    test(
      'updateProfileStatsAfterTrip deve incrementar kms e viagens',
      () async {
        await firestore.collection('users').doc('user123').set({
          'sumKilometers': 100.0,
          'tripsCompleted': 1,
        });

        await repository.updateProfileStatsAfterTrip('user123', 20.0);
        final result = await firestore.collection('users').doc('user123').get();

        expect(result.data()!['sumKilometers'], 120.0);
        expect(result.data()!['tripsCompleted'], 2);
      },
    );
  });
}
