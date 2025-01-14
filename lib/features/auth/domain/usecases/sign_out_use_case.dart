import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';

class SignOutUseCase {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}
