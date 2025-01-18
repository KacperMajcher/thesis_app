import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_app/features/auth/data/datasources/auth_data_source.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockAuthStateStream extends Mock implements Stream<User?> {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthDataSource authDataSource;

  setUpAll(() {
    registerFallbackValue(MockUserCredential());
    registerFallbackValue(MockUser());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authDataSource = AuthDataSource(firebaseAuth: mockFirebaseAuth);
  });

  group('AuthDataSource - createUserWithEmailAndPassword', () {
    final mockUserCredential = MockUserCredential();
    final mockUser = MockUser();

    setUp(() {
      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async => {});
    });

    test(
        'should return UserCredential when createUserWithEmailAndPassword is successful',
        () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockUserCredential);

      final result = await authDataSource.createUserWithEmailAndPassword(
        email: 'test@majcher.com',
        password: 'password123',
        name: 'Test Kacper',
      );

      expect(result, isA<UserCredential>());
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@majcher.com',
            password: 'password123',
          )).called(1);
      verify(() => mockUser.updateDisplayName('Test Kacper')).called(1);
    });

    test('should throw exception when createUserWithEmailAndPassword fails',
        () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(
        Exception('Create user failed'),
      );

      expect(
        () => authDataSource.createUserWithEmailAndPassword(
          email: 'test@majcher.com',
          password: 'password123',
          name: 'Test Kacper',
        ),
        throwsA(isA<Exception>()),
      );

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@majcher.com',
            password: 'password123',
          )).called(1);
    });
  });
}
