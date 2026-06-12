import 'package:dio/dio.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/services/http_client.dart';
import 'package:vehicle_tracker/src/features/garage/data/repositories/vehicle_repository.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late FakeFirebaseFirestore firestore;
  late MockHttpClient httpClient;
  late MockDio dio;
  late VehicleRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    httpClient = MockHttpClient();
    dio = MockDio();
    when(() => httpClient.dio).thenReturn(dio);
    repository = VehicleRepository(httpClient, firestore);
  });

  group('VehicleRepository', () {
    test('getBrands parses list from API response', () async {
      final brandsJson = [
        {'code': '1', 'name': 'Fiat'},
      ];

      when(() => dio.get('/cars/brands')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cars/brands'),
          data: brandsJson,
          statusCode: 200,
        ),
      );

      final brands = await repository.getBrands();

      expect(brands, hasLength(1));
      expect(brands.first.codigo, '1');
      expect(brands.first.nome, 'Fiat');
    });

    test('getModels parses list from API response', () async {
      final modelsJson = [
        {'code': '2', 'name': 'Uno'},
      ];

      when(() => dio.get('/cars/brands/1/models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cars/brands/1/models'),
          data: modelsJson,
          statusCode: 200,
        ),
      );

      final models = await repository.getModels('1');

      expect(models, hasLength(1));
      expect(models.first.codigo, '2');
      expect(models.first.nome, 'Uno');
    });

    test('getYears parses list from API response', () async {
      final yearsJson = [
        {'code': '2010', 'name': '2010'},
      ];

      when(() => dio.get('/cars/brands/1/models/2/years')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/cars/brands/1/models/2/years'),
          data: yearsJson,
          statusCode: 200,
        ),
      );

      final years = await repository.getYears('1', '2');

      expect(years, hasLength(1));
      expect(years.first.codigo, '2010');
      expect(years.first.nome, '2010');
    });

    test('getMyGarage returns the saved vehicles from Firestore', () async {
      await firestore.collection('garage').doc('ABC1234').set({
        'plate': 'ABC1234',
        'brand': 'Fiat',
        'model': 'Uno',
        'year': '2010',
        'currentKm': 100.0,
        'status': 'available',
      });

      final vehicles = await repository.getMyGarage();

      expect(vehicles, hasLength(1));
      expect(vehicles.first.plate, 'ABC1234');
      expect(vehicles.first.brand, 'Fiat');
      expect(vehicles.first.model, 'Uno');
      expect(vehicles.first.currentKm, 100.0);
    });

    test('saveVehicle persists the vehicle to Firestore', () async {
      const vehicle = Vehicle(
        plate: 'ABC1234',
        brand: 'Fiat',
        model: 'Uno',
        year: '2010',
        currentKm: 100.0,
      );

      await repository.saveVehicle(vehicle);
      final snapshot = await firestore
          .collection('garage')
          .doc('ABC1234')
          .get();

      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['brand'], 'Fiat');
      expect(snapshot.data()!['model'], 'Uno');
      expect(snapshot.data()!['currentKm'], 100.0);
    });

    test('updateVehicleMileageAfterTrip increments currentKm', () async {
      await firestore.collection('garage').doc('ABC1234').set({
        'plate': 'ABC1234',
        'brand': 'Fiat',
        'model': 'Uno',
        'year': '2010',
        'currentKm': 100.0,
        'status': 'available',
      });

      await repository.updateVehicleMileageAfterTrip('ABC1234', 20.0);
      final snapshot = await firestore
          .collection('garage')
          .doc('ABC1234')
          .get();

      expect(snapshot.data()!['currentKm'], 120.0);
    });
  });
}
