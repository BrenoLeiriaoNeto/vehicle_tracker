import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_tracker/src/core/errors/auth_failures.dart';
import 'package:vehicle_tracker/src/features/auth/auth_data_exports.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity?> getCurrentUser(String id) async {
    try {
      final userDoc = await _firestore.collection('users').doc(id).get();

      return UserModel.fromJson(userDoc.data()!, userDoc.id);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const UserNotFoundFailure();
        case 'network-request-failed':
          throw const ServerFailure(
            'Sem conexão com a internet. Verifique sua rede.',
          );
        default:
          throw UnknownAuthFailure(e.message!);
      }
    } catch (_) {
      throw UnknownAuthFailure();
    }
  }

  @override
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) throw const UnknownAuthFailure();

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      return UserModel.fromJson(userDoc.data()!, userDoc.id);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const UserNotFoundFailure();
        case 'wrong-password':
          throw const WrongPasswordFailure();
        case 'invalid-email':
          throw const InvalidEmailFailure();
        case 'network-request-failed':
          throw const ServerFailure(
            'Sem conexão com a internet. Verifique sua rede.',
          );
        default:
          throw UnknownAuthFailure(e.message!);
      }
    } catch (e) {
      throw UnknownAuthFailure();
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) throw const UnknownAuthFailure();

      final newUser = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: 'driver',
      );

      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());

      return newUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw const InvalidEmailFailure();
        case 'weak-password':
          throw const WeakPasswordFailure();
        case 'email-already-in-use':
          throw const EmailAlreadyExistsFailure();
        case 'network-request-failed':
          throw const ServerFailure(
            'Sem conexão com a internet. Verifique sua rede.',
          );
        default:
          throw UnknownAuthFailure(e.message!);
      }
    } catch (e) {
      throw UnknownAuthFailure();
    }
  }
}
