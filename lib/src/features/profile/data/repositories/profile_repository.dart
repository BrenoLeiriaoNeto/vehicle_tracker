import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracker/src/features/profile/profile_data_exports.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class ProfileRepository implements IProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository(this._firestore);

  @override
  Future<void> deleteProfile(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir o perfil: $e');
    }
  }

  @override
  Future<Profile> getProfile(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();

      if (!doc.exists) {
        throw Exception('Perfil não encontrado para o ID fornecido');
      }

      return ProfileModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Erro ao buscar dados do perfil: $e');
    }
  }

  @override
  Future<Profile> updateProfile(String id, Profile profile) async {
    try {
      final model = ProfileModel(
        avatarUrl: profile.avatarUrl,
        bio: profile.bio,
        tripsCompleted: profile.tripsCompleted,
        sumKilometers: profile.sumKilometers,
        totalVehicles: profile.totalVehicles,
        memberSince: profile.memberSince,
      );

      await _firestore
          .collection('users')
          .doc(id)
          .set(model.toJson(), SetOptions(merge: true));

      return model;
    } catch (e) {
      throw Exception('Erro ao atualizar dados do perfil: $e');
    }
  }
}
