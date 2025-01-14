import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:thesis_app/features/auth/domain/usecases/sign_up_use_case.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final AuthRepository _authRepository;
  StreamSubscription<UserModel?>? _authStateSubscription;

  AuthCubit(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._authRepository,
  ) : super(
          const AuthState(
            status: LoginStatus.initial,
          ),
        ) {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          emit(
            state.copyWith(
              status: LoginStatus.success,
              user: user,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: LoginStatus.initial,
              user: null,
            ),
          );
        }
      },
    );
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.connecting,
      ),
    );
    try {
      final user = await _signInUseCase(
        email,
        password,
      );
      emit(
        state.copyWith(
          status: LoginStatus.success,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(
      state.copyWith(
        status: LoginStatus.connecting,
      ),
    );
    try {
      final user = await _signUpUseCase(
        email,
        password,
        name,
      );
      emit(
        state.copyWith(
          status: LoginStatus.firstLogin,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(
      state.copyWith(
        status: LoginStatus.connecting,
      ),
    );
    try {
      await _signOutUseCase();
      emit(
        state.copyWith(
          status: LoginStatus.initial,
          user: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
