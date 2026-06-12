import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/trip_data_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class MockWatchTripUsecase extends Mock implements WatchTripUsecase {}

class MockCreateTripUsecase extends Mock implements CreateTripUsecase {}

class MockUpdateTripUsecase extends Mock implements UpdateTripUsecase {}

class MockGetTrips extends Mock implements GetTrips {}

class MockGetInProgressTripsUsecase extends Mock
    implements GetInProgressTripsUsecase {}

class MockCompleteTripUsecase extends Mock implements CompleteTripUsecase {}

class MockDateTime extends Fake implements DateTime {}

void main() {
  late MockWatchTripUsecase watchTripUsecase;
  late MockCreateTripUsecase createTripUsecase;
  late MockUpdateTripUsecase updateTripUsecase;
  late MockGetTrips getTrips;
  late MockGetInProgressTripsUsecase getInProgressTripsUsecase;
  late MockCompleteTripUsecase completeTripUsecase;
  late TripController controller;

  setUpAll(() {
    registerFallbackValue(DateTime(2000, 1, 1));
  });

  setUp(() {
    watchTripUsecase = MockWatchTripUsecase();
    createTripUsecase = MockCreateTripUsecase();
    updateTripUsecase = MockUpdateTripUsecase();
    getTrips = MockGetTrips();
    getInProgressTripsUsecase = MockGetInProgressTripsUsecase();
    completeTripUsecase = MockCompleteTripUsecase();

    controller = TripController(
      watchTripUsecase,
      createTripUsecase,
      updateTripUsecase,
      getTrips,
      getInProgressTripsUsecase,
      completeTripUsecase,
    );
  });

  group('TripController', () {
    final trip = TripModel(
      id: 'trip1',
      userId: 'user1',
      vehicleId: 'v1',
      vehicleName: 'Uno',
      origin: 'A',
      destination: 'B',
      totalDistance: 100.0,
      currentKm: 0.0,
      status: TripStatus.pending,
      vehicleState: TripVehicleState.parked,
    );

    test('createTrip atualiza o estado com a nova viagem', () async {
      when(() => createTripUsecase(trip)).thenAnswer((_) async => trip);

      await controller.createTrip(trip);

      expect(controller.state.trip, trip);
      expect(controller.state.status, TripStatus.pending);
      expect(controller.state.isLoading, isFalse);
    });

    test('getMyTrips atualiza a lista de viagens', () async {
      final trips = [trip];
      when(() => getTrips()).thenAnswer((_) async => trips);

      await controller.getMyTrips();

      expect(controller.state.trips, trips);
      expect(controller.state.isLoading, isFalse);
    });

    test('startTrip deve transitar para inProgress e moving', () async {
      final updatedTrip = trip.copyWith(
        currentKm: 10.0,
        vehicleState: TripVehicleState.moving,
      );
      when(
        () => updateTripUsecase('trip1', 10.0, TripVehicleState.moving),
      ).thenAnswer((_) async => updatedTrip);

      await controller.startTrip('trip1', 10.0, TripVehicleState.moving);

      expect(controller.state.status, TripStatus.inProgress);
      expect(controller.state.vehicleState, TripVehicleState.moving);
      expect(controller.state.trip, updatedTrip);
      expect(controller.state.isLoading, isFalse);
    });

    test('stopVehicle deve transitar para paused e idle', () async {
      final updatedTrip = trip.copyWith(
        currentKm: 20.0,
        vehicleState: TripVehicleState.idle,
      );
      when(
        () => updateTripUsecase('trip1', 20.0, TripVehicleState.idle),
      ).thenAnswer((_) async => updatedTrip);

      await controller.stopVehicle('trip1', 20.0, TripVehicleState.idle);

      expect(controller.state.status, TripStatus.paused);
      expect(controller.state.vehicleState, TripVehicleState.idle);
      expect(controller.state.trip, updatedTrip);
      expect(controller.state.isLoading, isFalse);
    });

    test('resumeTrip deve transitar para inProgress e moving', () async {
      final updatedTrip = trip.copyWith(
        currentKm: 30.0,
        vehicleState: TripVehicleState.moving,
      );
      when(
        () => updateTripUsecase('trip1', 30.0, TripVehicleState.moving),
      ).thenAnswer((_) async => updatedTrip);

      await controller.resumeTrip('trip1', 30.0, TripVehicleState.moving);

      expect(controller.state.status, TripStatus.inProgress);
      expect(controller.state.vehicleState, TripVehicleState.moving);
      expect(controller.state.trip, updatedTrip);
      expect(controller.state.isLoading, isFalse);
    });

    test(
      'completeTrip deve limpar a viagem e atualizar o estado para completed',
      () async {
        when(
          () => completeTripUsecase('trip1', any(), 100.0),
        ).thenAnswer((_) async => trip);

        await controller.completeTrip('trip1', DateTime.now(), 100.0);

        expect(controller.state.trip, isNull);
        expect(controller.state.status, TripStatus.completed);
        expect(controller.state.vehicleState, TripVehicleState.parked);
        expect(controller.state.isLoading, isFalse);
      },
    );

    test(
      'logoutClear cancela subscriptions e timers e retorna false quando não havia stream',
      () async {
        final result = await controller.logoutClear();

        expect(result, isFalse);
        expect(controller.state.status, TripStatus.pending);
      },
    );
  });
}
