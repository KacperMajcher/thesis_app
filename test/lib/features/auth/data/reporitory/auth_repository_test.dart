import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepository authRepository;

  setUpAll(() {
    registerFallbackValue(MockUser());
    registerFallbackValue(MockUserCredential());
  });

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    authRepository = AuthRepository(mockAuthDataSource);
  });

  group('AuthRepository', () {
    final mockUser = MockUser();
    final mockUserCredential = MockUserCredential();

    setUp(() {
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn('test@majcher.com');
      when(() => mockUser.displayName).thenReturn('Test Kacper');
      when(() => mockUserCredential.user).thenReturn(mockUser);
    });

    group('signInWithEmailAndPassword', () {
      test('returns UserModel when signIn is successful', () async {
        when(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authRepository.signInWithEmailAndPassword(
          'test@majcher.com',
          'password123',
        );

        expect(result, isA<UserModel>());
        expect(result.id, '123');
        expect(result.email, 'test@majcher.com');
        expect(result.displayName, 'Test Kacper');

        verify(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: 'test@majcher.com',
              password: 'password123',
            )).called(1);
      });
    });
  });
}
