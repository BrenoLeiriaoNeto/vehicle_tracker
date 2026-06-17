import 'dart:async';

import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/trip/state/trip_state.dart';
import 'package:vehicle_tracker/src/features/trip/trip_data_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripController extends Ion<TripState> {
  final WatchTripUsecase _watchTripUsecase;
  final CreateTripUsecase _createTripUsecase;
  final UpdateTripUsecase _updateTripUsecase;
  final GetTrips _getTrips;
  final GetInProgressTripsUsecase _getInProgressTripsUsecase;
  final CompleteTripUsecase _completeTripUsecase;

  StreamSubscription<Trip?>? _tripSubscription;
  Timer? _simulationTimer;

  TripController(
    this._watchTripUsecase,
    this._createTripUsecase,
    this._updateTripUsecase,
    this._getTrips,
    this._getInProgressTripsUsecase,
    this._completeTripUsecase,
  ) : super(.initial());

  void startLocalSimulation() {
    _simulationTimer?.cancel();

    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final activeTrips = state.activeTrips;

      if (activeTrips.isEmpty) {
        timer.cancel();
        _simulationTimer = null;
        return;
      }

      final List<Trip> updatedTrips = [];

      for (final trip in activeTrips) {
        final tripModel = TripModel.fromEntity(trip);
        final double totalKm = tripModel.totalDistance;
        final double nextKm = tripModel.currentKm + 10.0;

        if (nextKm >= totalKm) {
          _completeTripUsecase(
            tripModel.id,
            DateTime.now(),
            totalKm,
          ).catchError(
            (e) => throw Exception('Deu algum erro ao finalizar a viagem: $e'),
          );
        } else {
          final updatedTrip = tripModel.copyWith(
            currentKm: nextKm,
            vehicleState: .moving,
          );
          updatedTrips.add(updatedTrip);

          _updateTripUsecase(tripModel.id, nextKm, .moving).catchError(
            (e) => throw Exception('Erro ao atualizar a viagem: $e'),
          );
        }
      }

      set(state.copyWith(activeTrips: updatedTrips));
    });
  }

  void watchTrip(String userId) {
    _tripSubscription?.cancel();

    set(state.copyWith(isLoading: true));

    _tripSubscription = _watchTripUsecase(userId).listen(
      (activeTrip) {
        if (activeTrip != null) {
          set(
            state.copyWith(
              trip: activeTrip,
              status: activeTrip.status,
              vehicleState: activeTrip.vehicleState,
              isLoading: false,
              errorMessage: null,
            ),
          );
        } else {
          set(
            state.copyWith(
              trip: null,
              status: .pending,
              vehicleState: .parked,
              isLoading: false,
            ),
          );
        }
      },
      onError: (e) {
        set(state.copyWith(errorMessage: e.toString(), isLoading: false));
      },
    );
  }

  Future<void> fetchActiveTrip(String userId) async {
    set(state.copyWith(isLoading: true));

    try {
      final activeTrips = await _getInProgressTripsUsecase(userId);

      set(
        state.copyWith(
          activeTrips: activeTrips,
          isLoading: false,
          errorMessage: null,
        ),
      );

      if (activeTrips.isNotEmpty && _simulationTimer == null) {
        startLocalSimulation();
      }
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> createTrip(Trip trip) async {
    set(state.copyWith(isLoading: true));

    try {
      final newTrip = await _createTripUsecase(trip);

      set(
        state.copyWith(
          status: newTrip.status,
          vehicleState: newTrip.vehicleState,
          trip: newTrip,
          isLoading: false,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> startTrip(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      final trip = await _updateTripUsecase(tripId, currentKm, vehicleState);

      set(
        state.copyWith(
          status: .inProgress,
          vehicleState: .moving,
          isLoading: false,
          trip: trip,
          errorMessage: null,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> getMyTrips() async {
    set(state.copyWith(isLoading: true));
    try {
      final trips = await _getTrips();

      set(state.copyWith(historyTrips: trips, isLoading: false));
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> completeTrip(
    String tripId,
    DateTime completedAt,
    double finalKm,
  ) async {
    set(state.copyWith(isLoading: true));

    try {
      await _completeTripUsecase(tripId, completedAt, finalKm);

      set(
        state.copyWith(
          status: .completed,
          vehicleState: .parked,
          trip: null,
          isLoading: false,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> stopVehicle(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      final trip = await _updateTripUsecase(tripId, currentKm, vehicleState);

      set(
        state.copyWith(
          isLoading: false,
          trip: trip,
          vehicleState: .idle,
          status: .paused,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> resumeTrip(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      final trip = await _updateTripUsecase(tripId, currentKm, vehicleState);

      set(
        state.copyWith(
          isLoading: false,
          status: .inProgress,
          vehicleState: .moving,
          trip: trip,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<bool> logoutClear() async {
    final hasActiveStream = _tripSubscription != null;
    final hasActiveTimer = _simulationTimer != null;

    if (hasActiveStream) {
      await _tripSubscription?.cancel();
      _tripSubscription = null;
    }

    if (hasActiveTimer) {
      _simulationTimer?.cancel();
      _simulationTimer = null;
    }

    set(.initial());

    return hasActiveStream;
  }

  @override
  void dispose() {
    _tripSubscription?.cancel();
    _simulationTimer?.cancel();
    super.dispose();
  }
}
