import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracker/src/features/trip/trip_data_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripRepository implements ITripRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'trips';

  TripRepository(this._firestore);

  @override
  Future<Trip> completeTrip(String tripId, DateTime completedAt) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update({
        'status': TripStatus.completed.name,
        'vehicleState': TripVehicleState.parked.name,
        'completedAt': completedAt.toIso8601String(),
      });

      final doc = await _firestore.collection(_collection).doc(tripId).get();
      return TripModel.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Erro ao finalizar viagem: $e');
    }
  }

  @override
  Future<Trip> createTrip(Trip trip) async {
    try {
      final model = TripModel.fromEntity(trip);

      await _firestore.collection(_collection).doc(model.id).set(model.toMap());

      return model;
    } catch (e) {
      throw Exception('Erro ao criar viagem: $e');
    }
  }

  @override
  Future<List<Trip>> getTripHistory(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: TripStatus.completed.name)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => TripModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Erro ao buscar histórico de viagens: $e');
    }
  }

  @override
  Future<List<Trip>> getTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => TripModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Erro ao buscar viagens: $e');
    }
  }

  @override
  Future<Trip> updateTrip(
    String tripId,
    double currentKm,
    TripVehicleState state,
  ) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update({
        'currentKm': currentKm,
        'vehicleState': state.name,
      });

      final doc = await _firestore.collection(_collection).doc(tripId).get();
      return TripModel.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Erro ao atualizar progresso: $e');
    }
  }

  @override
  Stream<Trip?> watchActiveTrip(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where(
          'status',
          whereIn: [TripStatus.inProgress.name, TripStatus.paused.name],
        )
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return TripModel.fromMap(snapshot.docs.first.data());
        })
        .handleError((e) {
          throw Exception('Erro ao trazer informações da viagem: $e');
        });
  }
}
