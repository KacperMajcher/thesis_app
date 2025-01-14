import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<UserModel> call(String email, String password, String name) async {
    try {
      return await _repository.signUp(email, password, name);
    } catch (e) {
      rethrow;
    }
  }
}
