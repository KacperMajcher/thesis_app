import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_app/core/exceptions/auth_exception.dart';
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

      test('throws AuthException when signIn fails', () async {
        when(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Sign in failed'));

        expect(
          () => authRepository.signInWithEmailAndPassword(
            'test@majcher.com',
            'wrongpassword',
          ),
          throwsA(isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Failed to sign in with email/password. Please check your credentials and try again.',
          )),
        );

        verify(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: 'test@majcher.com',
              password: 'wrongpassword',
            )).called(1);
      });
    });

    group('signUp', () {
      test('returns UserModel when signUp is successful', () async {
        when(() => mockAuthDataSource.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authRepository.signUp(
          'test@majcher.com',
          'password123',
          'Test Kacper',
        );

        expect(result, isA<UserModel>());
        expect(result.id, '123');
        expect(result.email, 'test@majcher.com');
        expect(result.displayName, 'Test Kacper');

        verify(() => mockAuthDataSource.createUserWithEmailAndPassword(
              email: 'test@majcher.com',
              password: 'password123',
              name: 'Test Kacper',
            )).called(1);
      });

      test('throws AuthException when signUp fails', () async {
        when(() => mockAuthDataSource.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(Exception('Sign up failed'));

        expect(
          () => authRepository.signUp(
            'test@majcher.com',
            'password123',
            'Test Kacper',
          ),
          throwsA(isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Failed to create account. Please try again.',
          )),
        );

        verify(() => mockAuthDataSource.createUserWithEmailAndPassword(
              email: 'test@majcher.com',
              password: 'password123',
              name: 'Test Kacper',
            )).called(1);
      });
    });
  });
}
