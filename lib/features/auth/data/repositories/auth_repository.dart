import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_app/core/exceptions/auth_exception.dart';
import 'package:thesis_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';

class AuthRepository {
  AuthRepository(this._dataSource);

  final AuthDataSource _dataSource;

  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userModel(userCredential.user);
    } catch (e) {
      log(
        'signInWithEmailAndPassword error: $e',
      );
      throw AuthException(
        'Failed to sign in with email/password. Please check your credentials and try again.',
      );
    }
  }

  Future<UserModel> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _dataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      return _userModel(
        userCredential.user,
        isFirstLogin: true,
      );
    } catch (e) {
      log(
        'signUp error: $e',
      );
      throw AuthException(
        'Failed to create account. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      log(
        'signOut error: $e',
      );
      throw AuthException(
        'Failed to sign out. Please try again.',
      );
    }
  }

  Stream<UserModel?> get authStateChanges => _dataSource
      .authStateChanges()
      .map((user) => user != null ? _userModel(user) : null);

  UserModel? getCurrentUser() {
    final user = _dataSource.getCurrentUser();
    return user != null ? _userModel(user) : null;
  }

  UserModel _userModel(User? user, {bool isFirstLogin = false}) {
    if (user == null) {
      throw Exception('User is null');
    }
    return UserModel(
      id: user.uid,
      email: user.email!,
      displayName: user.displayName ?? '',
    );
  }
}
