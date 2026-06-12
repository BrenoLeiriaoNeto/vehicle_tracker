import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/auth/auth_data_exports.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  late AuthRepository repository;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    repository = AuthRepository(firebaseAuth, firestore);
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  group('AuthRepository', () {
    test(
      'loginWithEmailAndPassword retorna UserEntity quando credenciais estão corretas',
      () async {
        const uid = 'user123';
        const email = 'test@example.com';
        const name = 'Teste';

        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: 'senha',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(uid);

        await firestore.collection('users').doc(uid).set({
          'email': email,
          'name': name,
          'role': 'driver',
        });

        final result = await repository.loginWithEmailAndPassword(
          email: email,
          password: 'senha',
        );

        expect(result.id, uid);
        expect(result.email, email);
        expect(result.name, name);
        expect(result.role, 'driver');
      },
    );

    test(
      'signUpWithEmailAndPassword salva o usuário e retorna UserEntity',
      () async {
        const uid = 'new_user';
        const email = 'new@example.com';
        const name = 'Novo Usuário';

        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: 'senha',
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(uid);
        when(() => firebaseAuth.currentUser).thenReturn(mockUser);

        final result = await repository.signUpWithEmailAndPassword(
          name: name,
          email: email,
          password: 'senha',
        );

        final savedUser = await firestore.collection('users').doc(uid).get();

        expect(result.id, uid);
        expect(result.email, email);
        expect(result.name, name);
        expect(savedUser.exists, isTrue);
        expect(savedUser.data(), containsPair('name', name));
        expect(savedUser.data(), containsPair('email', email));
      },
    );

    test('logout chama signOut no FirebaseAuth', () async {
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => firebaseAuth.signOut()).called(1);
    });
  });
}
