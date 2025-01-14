import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<UserModel> call(String email, String password) =>
      _repository.signInWithEmailAndPassword(email, password);
}
