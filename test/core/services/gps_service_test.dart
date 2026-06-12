import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vehicle_tracker/src/core/services/gps_service.dart';

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

class MockGeocodingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeocodingPlatform {}

class MockPosition extends Mock implements Position {}

void main() {
  late MockGeolocatorPlatform mockGeolocatorPlatform;
  late MockGeocodingPlatform mockGeocodingPlatform;
  late MockPosition mockPosition;

  setUpAll(() {
    registerFallbackValue(MockPosition());
  });

  setUp(() {
    mockGeolocatorPlatform = MockGeolocatorPlatform();
    mockGeocodingPlatform = MockGeocodingPlatform();
    mockPosition = MockPosition();

    GeolocatorPlatform.instance = mockGeolocatorPlatform;
    GeocodingPlatform.instance = mockGeocodingPlatform;
  });

  test(
    'getPosition returns current position when permission is granted',
    () async {
      when(
        () => mockGeolocatorPlatform.checkPermission(),
      ).thenAnswer((_) async => LocationPermission.whileInUse);
      when(
        () => mockGeolocatorPlatform.getLastKnownPosition(
          forceLocationManager: any(named: 'forceLocationManager'),
        ),
      ).thenAnswer((_) async => null);
      when(
        () => mockGeolocatorPlatform.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer((_) async => mockPosition);

      final result = await getPosition();

      expect(result, mockPosition);
    },
  );

  test(
    'fetchCurrentLocation returns formatted address when service is enabled',
    () async {
      when(
        () => mockGeolocatorPlatform.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(
        () => mockGeolocatorPlatform.checkPermission(),
      ).thenAnswer((_) async => LocationPermission.whileInUse);
      when(
        () => mockGeolocatorPlatform.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        ),
      ).thenAnswer((_) async => mockPosition);
      when(() => mockPosition.latitude).thenReturn(-23.5);
      when(() => mockPosition.longitude).thenReturn(-46.6);
      when(
        () => mockGeocodingPlatform.placemarkFromCoordinates(any(), any()),
      ).thenAnswer(
        (_) async => [
          Placemark(
            thoroughfare: 'Rua Teste',
            subAdministrativeArea: 'Cidade Teste',
          ),
        ],
      );

      final result = await fetchCurrentLocation();

      expect(result, 'Rua Teste, Cidade Teste');
    },
  );

  test(
    'fetchCurrentLocation throws when location service is disabled',
    () async {
      when(
        () => mockGeolocatorPlatform.isLocationServiceEnabled(),
      ).thenAnswer((_) async => false);

      expect(
        fetchCurrentLocation(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro de GPS: O serviço de localização'),
          ),
        ),
      );
    },
  );
}
