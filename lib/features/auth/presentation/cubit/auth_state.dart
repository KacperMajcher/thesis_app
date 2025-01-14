part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(LoginStatus.initial) LoginStatus status,
    UserModel? user,
    String? errorMessage,
  }) = _AuthState;
}
