import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthCubit authCubit;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream<UserModel?>.empty());
    authCubit = AuthCubit(
      SignInUseCase(mockAuthRepository),
      SignUpUseCase(mockAuthRepository),
      SignOutUseCase(mockAuthRepository),
      mockAuthRepository,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit - Sign In', () {
    final testUser = UserModel(
      id: '1',
      email: 'kacper@majcher.com',
      displayName: 'Kacper Majcher',
    );

    blocTest<AuthCubit, AuthState>(
      'Emits [connecting, success] states when signIn succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => testUser);
        return authCubit;
      },
      act: (cubit) => cubit.signIn('kacper@majcher.com', 'password123'),
      expect: () => [
        const AuthState(status: LoginStatus.connecting),
        AuthState(status: LoginStatus.success, user: testUser),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
              'kacper@majcher.com',
              'password123',
            )).called(1);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'Emits [connecting, error] states when signIn fails',
      build: () {
        when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
            .thenThrow(Exception('Invalid credentials'));

        return authCubit;
      },
      act: (cubit) => cubit.signIn('kacper@majcher.com', 'wrongpassword'),
      expect: () => [
        const AuthState(status: LoginStatus.connecting),
        AuthState(
          status: LoginStatus.error,
          errorMessage: 'Invalid credentials',
        ),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
              'kacper@majcher.com',
              'wrongpassword',
            )).called(1);
      },
    );
  });

  group('AuthCubit - Sign Out', () {
    final testUser = UserModel(
      id: '1',
      email: 'kacper@majcher.com',
      displayName: 'Kacper Majcher',
    );

    blocTest<AuthCubit, AuthState>(
      'Emits [connecting, initial] states when signOut succeeds',
      build: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async => {});
        return authCubit;
      },
      seed: () => AuthState(
        status: LoginStatus.success,
        user: testUser,
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        AuthState(status: LoginStatus.connecting, user: testUser),
        const AuthState(status: LoginStatus.initial, user: null),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'Emits [connecting, error] states when signOut fails',
      build: () {
        when(() => mockAuthRepository.signOut()).thenThrow(
          Exception('Sign out failed'),
        );
        return authCubit;
      },
      seed: () => AuthState(
        status: LoginStatus.success,
        user: testUser,
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        AuthState(status: LoginStatus.connecting, user: testUser),
        AuthState(
          status: LoginStatus.error,
          errorMessage: 'Sign out failed',
          user: testUser,
        ),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );
  });

  group('AuthCubit - Sign Up', () {
    final newUser = UserModel(
      id: '2',
      email: 'kacper2@majcher.com',
      displayName: 'Kacper Majcher',
    );

    blocTest<AuthCubit, AuthState>(
      'Emits [connecting, firstLogin] state when signUp succeeds',
      build: () {
        when(() => mockAuthRepository.signUp(any(), any(), any()))
            .thenAnswer((_) async => newUser);
        return authCubit;
      },
      act: (cubit) =>
          cubit.signUp('kacper2@majcher.com', 'password123', 'Kacper Majcher'),
      expect: () => [
        const AuthState(status: LoginStatus.connecting),
        AuthState(status: LoginStatus.firstLogin, user: newUser),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signUp(
              'kacper2@majcher.com',
              'password123',
              'Kacper Majcher',
            )).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [connecting, error] when signUp fails',
      build: () {
        when(() => mockAuthRepository.signUp(any(), any(), any()))
            .thenThrow(Exception('Email already in use'));
        return authCubit;
      },
      act: (cubit) =>
          cubit.signUp('kacper2@majcher.com', 'password123', 'Kacper Majcher'),
      expect: () => [
        const AuthState(status: LoginStatus.connecting),
        AuthState(
          status: LoginStatus.error,
          errorMessage: 'Email already in use',
        ),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signUp(
              'kacper2@majcher.com',
              'password123',
              'Kacper Majcher',
            )).called(1);
      },
    );
  });
}
