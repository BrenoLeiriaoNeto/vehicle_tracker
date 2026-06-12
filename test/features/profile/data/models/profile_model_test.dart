import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/profile/profile_data_exports.dart';

void main() {
  group('ProfileModel', () {
    test('fromJson deve desserializar corretamente os campos', () {
      final memberSince = DateTime(2021, 1, 15);
      final model = ProfileModel.fromJson({
        'avatarUrl': 'https://image.url/avatar.png',
        'bio': 'Testando aplica\u00e7\u00e3o',
        'tripsCompleted': 12,
        'sumKilometers': 1234.5,
        'totalVehicles': 2,
        'memberSince': Timestamp.fromDate(memberSince),
      });

      expect(model.avatarUrl, 'https://image.url/avatar.png');
      expect(model.bio, 'Testando aplica\u00e7\u00e3o');
      expect(model.tripsCompleted, 12);
      expect(model.sumKilometers, 1234.5);
      expect(model.totalVehicles, 2);
      expect(model.memberSince, memberSince);
    });

    test('toJson deve serializar valores corretamente', () {
      final memberSince = DateTime(2021, 1, 15);
      final model = ProfileModel(
        avatarUrl: 'https://image.url/avatar.png',
        bio: 'Testando aplica\u00e7\u00e3o',
        tripsCompleted: 12,
        sumKilometers: 1234.5,
        totalVehicles: 2,
        memberSince: memberSince,
      );

      final json = model.toJson();

      expect(json['avatarUrl'], 'https://image.url/avatar.png');
      expect(json['bio'], 'Testando aplica\u00e7\u00e3o');
      expect(json['tripsCompleted'], 12);
      expect(json['sumKilometers'], 1234.5);
      expect(json['totalVehicles'], 2);
      expect(json['memberSince'], isA<Timestamp>());
    });
  });
}
