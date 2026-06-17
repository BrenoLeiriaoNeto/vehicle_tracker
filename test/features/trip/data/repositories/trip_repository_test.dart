import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/trip_data_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TripRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = TripRepository(firestore);
  });

  group('TripRepository', () {
    test('createTrip persists and returns the created trip', () async {
      final trip = Trip(
        id: 'trip1',
        userId: 'user1',
        vehicleId: 'vehicle1',
        vehicleName: 'Fiat Uno',
        origin: 'A',
        destination: 'B',
        totalDistance: 120.0,
        currentKm: 0.0,
        status: TripStatus.inProgress,
        vehicleState: TripVehicleState.moving,
        startedAt: DateTime.parse('2024-01-01T10:00:00Z'),
      );

      final result = await repository.createTrip(trip);

      expect(result.id, trip.id);
      expect(result.status, TripStatus.inProgress);
      expect(result.vehicleState, TripVehicleState.moving);

      final snapshot = await firestore.collection('trips').doc('trip1').get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['userId'], 'user1');
    });

    test('updateTrip updates the trip and returns the updated model', () async {
      final originalTrip = Trip(
        id: 'trip2',
        userId: 'user1',
        vehicleId: 'vehicle1',
        vehicleName: 'Fiat Uno',
        origin: 'A',
        destination: 'B',
        totalDistance: 120.0,
        currentKm: 30.0,
        status: TripStatus.inProgress,
        vehicleState: TripVehicleState.moving,
      );
      await firestore
          .collection('trips')
          .doc(originalTrip.id)
          .set(TripModel.fromEntity(originalTrip).toMap());

      final result = await repository.updateTrip(
        originalTrip.id,
        60.0,
        TripVehicleState.idle,
      );

      expect(result.currentKm, 60.0);
      expect(result.vehicleState, TripVehicleState.idle);
    });

    test(
      'completeTrip updates status and returns the completed trip',
      () async {
        final originalTrip = Trip(
          id: 'trip3',
          userId: 'user1',
          vehicleId: 'vehicle1',
          vehicleName: 'Fiat Uno',
          origin: 'A',
          destination: 'B',
          totalDistance: 120.0,
          currentKm: 80.0,
          status: TripStatus.inProgress,
          vehicleState: TripVehicleState.moving,
        );
        await firestore
            .collection('trips')
            .doc(originalTrip.id)
            .set(TripModel.fromEntity(originalTrip).toMap());

        final completedAt = DateTime.parse('2024-01-02T12:00:00Z');
        final result = await repository.completeTrip(
          originalTrip.id,
          completedAt,
          120.0,
        );

        expect(result.status, TripStatus.completed);
        expect(result.vehicleState, TripVehicleState.parked);
        expect(result.currentKm, 120.0);
      },
    );

    test(
      'getTripHistory returns only completed trips ordered by completedAt',
      () async {
        final olderTrip = Trip(
          id: 'trip4',
          userId: 'user1',
          vehicleId: 'vehicle1',
          vehicleName: 'Fiat Uno',
          origin: 'A',
          destination: 'B',
          totalDistance: 120.0,
          currentKm: 120.0,
          status: TripStatus.completed,
          vehicleState: TripVehicleState.parked,
          completedAt: DateTime.parse('2024-01-01T10:00:00Z'),
        );
        final newerTrip = Trip(
          id: 'trip5',
          userId: 'user1',
          vehicleId: 'vehicle1',
          vehicleName: 'Fiat Uno',
          origin: 'A',
          destination: 'B',
          totalDistance: 120.0,
          currentKm: 120.0,
          status: TripStatus.completed,
          vehicleState: TripVehicleState.parked,
          completedAt: DateTime.parse('2024-01-02T10:00:00Z'),
        );

        await firestore
            .collection('trips')
            .doc(olderTrip.id)
            .set(TripModel.fromEntity(olderTrip).toMap());
        await firestore
            .collection('trips')
            .doc(newerTrip.id)
            .set(TripModel.fromEntity(newerTrip).toMap());
        await firestore.collection('trips').doc('trip6').set({
          'id': 'trip6',
          'userId': 'user1',
          'vehicleId': 'vehicle1',
          'vehicleName': 'Fiat Uno',
          'origin': 'A',
          'destination': 'B',
          'totalDistance': 100.0,
          'currentKm': 50.0,
          'status': TripStatus.inProgress.name,
          'vehicleState': TripVehicleState.moving.name,
          'startedAt': DateTime.parse('2024-01-03T10:00:00Z').toIso8601String(),
        });

        final history = await repository.getTripHistory('user1');

        expect(history, hasLength(2));
        expect(history.first.id, newerTrip.id);
        expect(history.last.id, olderTrip.id);
      },
    );

    test('getTrips returns all trips for a user', () async {
      await firestore
          .collection('trips')
          .doc('trip7')
          .set(
            TripModel.fromEntity(
              Trip(
                id: 'trip7',
                userId: 'user1',
                vehicleId: 'vehicle1',
                vehicleName: 'Fiat Uno',
                origin: 'A',
                destination: 'B',
                totalDistance: 120.0,
                currentKm: 0.0,
                status: TripStatus.inProgress,
                vehicleState: TripVehicleState.moving,
              ),
            ).toMap(),
          );
      await firestore
          .collection('trips')
          .doc('trip8')
          .set(
            TripModel.fromEntity(
              Trip(
                id: 'trip8',
                userId: 'user1',
                vehicleId: 'vehicle2',
                vehicleName: 'Ford Fiesta',
                origin: 'C',
                destination: 'D',
                totalDistance: 80.0,
                currentKm: 0.0,
                status: TripStatus.inProgress,
                vehicleState: TripVehicleState.moving,
              ),
            ).toMap(),
          );

      final trips = await repository.getTrips('user1');

      expect(trips, hasLength(2));
      expect(trips.map((t) => t.id), containsAll(['trip7', 'trip8']));
    });

    test('getInProgressTrips returns only trips in progress', () async {
      await firestore
          .collection('trips')
          .doc('trip9')
          .set(
            TripModel.fromEntity(
              Trip(
                id: 'trip9',
                userId: 'user1',
                vehicleId: 'vehicle1',
                vehicleName: 'Fiat Uno',
                origin: 'A',
                destination: 'B',
                totalDistance: 120.0,
                currentKm: 20.0,
                status: TripStatus.inProgress,
                vehicleState: TripVehicleState.moving,
              ),
            ).toMap(),
          );
      await firestore
          .collection('trips')
          .doc('trip10')
          .set(
            TripModel.fromEntity(
              Trip(
                id: 'trip10',
                userId: 'user1',
                vehicleId: 'vehicle1',
                vehicleName: 'Fiat Uno',
                origin: 'A',
                destination: 'B',
                totalDistance: 120.0,
                currentKm: 20.0,
                status: TripStatus.completed,
                vehicleState: TripVehicleState.parked,
              ),
            ).toMap(),
          );

      final inProgress = await repository.getInProgressTrips('user1');

      expect(inProgress, hasLength(1));
      expect(inProgress.first.id, 'trip9');
    });
  });
}
