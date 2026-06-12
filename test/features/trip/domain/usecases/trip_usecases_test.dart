import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class MockITripRepository extends Mock implements ITripRepository {}

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime(2000, 1, 1));
  });

  late MockITripRepository tripRepository;
  late MockIAuthRepository authRepository;

  setUp(() {
    tripRepository = MockITripRepository();
    authRepository = MockIAuthRepository();
  });

  group('GetTrips', () {
    test('deve buscar viagens usando o id do usuário', () async {
      final usecase = GetTrips(tripRepository, authRepository);
      const userId = 'user_1';
      final trips = <Trip>[];

      when(() => authRepository.getCurrentUserId()).thenReturn(userId);
      when(
        () => tripRepository.getTrips(userId),
      ).thenAnswer((_) async => trips);

      final result = await usecase.call();

      expect(result, trips);
    });
  });

  group('CreateTripUsecase', () {
    test('deve criar a viagem usando o repositório', () async {
      final usecase = CreateTripUsecase(tripRepository);
      final trip = Trip(
        id: 'trip1',
        userId: 'user_1',
        vehicleId: 'v1',
        vehicleName: 'Uno',
        origin: 'A',
        destination: 'B',
        totalDistance: 100.0,
        currentKm: 0.0,
        status: TripStatus.pending,
        vehicleState: TripVehicleState.parked,
      );

      when(() => tripRepository.createTrip(trip)).thenAnswer((_) async => trip);

      final result = await usecase.call(trip);

      expect(result, trip);
    });
  });

  group('UpdateTripUsecase', () {
    test('deve atualizar a viagem no repositório', () async {
      final usecase = UpdateTripUsecase(tripRepository);
      final trip = Trip(
        id: 'trip1',
        userId: 'user_1',
        vehicleId: 'v1',
        vehicleName: 'Uno',
        origin: 'A',
        destination: 'B',
        totalDistance: 100.0,
        currentKm: 20.0,
        status: TripStatus.inProgress,
        vehicleState: TripVehicleState.moving,
      );

      when(
        () => tripRepository.updateTrip('trip1', 20.0, TripVehicleState.moving),
      ).thenAnswer((_) async => trip);

      final result = await usecase.call('trip1', 20.0, TripVehicleState.moving);

      expect(result, trip);
    });
  });

  group('WatchTripUsecase', () {
    test('deve expor o stream do repositório', () {
      final usecase = WatchTripUsecase(tripRepository);
      final stream = Stream<Trip?>.fromIterable([null]);

      when(
        () => tripRepository.watchActiveTrip('user_1'),
      ).thenAnswer((_) => stream);

      expect(usecase.call('user_1'), emitsInOrder([null]));
    });
  });

  group('GetInProgressTripsUsecase', () {
    test('deve retornar viagens em andamento do repositório', () async {
      final usecase = GetInProgressTripsUsecase(tripRepository);
      final trips = <Trip>[];

      when(
        () => tripRepository.getInProgressTrips('user_1'),
      ).thenAnswer((_) async => trips);

      final result = await usecase.call('user_1');

      expect(result, trips);
    });
  });

  group('CompleteTripUsecase', () {
    test('deve completar viagem e atualizar veículo e perfil', () async {
      final mockVehicleRepository = MockIVehicleRepository();
      final mockProfileRepository = MockIProfileRepository();
      final usecase = CompleteTripUsecase(
        tripRepository,
        mockVehicleRepository,
        mockProfileRepository,
      );
      final completedTrip = Trip(
        id: 'trip1',
        userId: 'user_1',
        vehicleId: 'v1',
        vehicleName: 'Uno',
        origin: 'A',
        destination: 'B',
        totalDistance: 100.0,
        currentKm: 100.0,
        status: TripStatus.completed,
        vehicleState: TripVehicleState.parked,
      );

      when(
        () => tripRepository.completeTrip('trip1', any(), 100.0),
      ).thenAnswer((_) async => completedTrip);
      when(
        () => mockVehicleRepository.updateVehicleMileageAfterTrip('v1', 100.0),
      ).thenAnswer((_) async {});
      when(
        () =>
            mockProfileRepository.updateProfileStatsAfterTrip('user_1', 100.0),
      ).thenAnswer((_) async {});

      final result = await usecase.call('trip1', DateTime.now(), 100.0);

      expect(result, completedTrip);
      verify(
        () => mockVehicleRepository.updateVehicleMileageAfterTrip('v1', 100.0),
      ).called(1);
      verify(
        () =>
            mockProfileRepository.updateProfileStatsAfterTrip('user_1', 100.0),
      ).called(1);
    });
  });
}

class MockIVehicleRepository extends Mock implements IVehicleRepository {}

class MockIProfileRepository extends Mock implements IProfileRepository {}
