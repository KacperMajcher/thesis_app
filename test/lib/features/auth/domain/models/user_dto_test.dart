
import 'package:flutter_test/flutter_test.dart';
import 'package:thesis_app/features/auth/domain/models/user_dto.dart';
import 'package:thesis_app/features/auth/domain/models/user_model.dart';

void main() {
  group('UserDto', () {
    final testJson = {
      'id': '1',
      'email': 'kacper@majcher.com',
      'display_name': 'Kacper Majcher',
    };

    final userDto = UserDto(
      id: '1',
      email: 'kacper@majcher.com',
      displayName: 'Kacper Majcher',
    );

    final userModel = UserModel(
      id: '1',
      email: 'kacper@majcher.com',
      displayName: 'Kacper Majcher',
    );

    test('should correctly deserialize from JSON', () {
      final result = UserDto.fromJson(testJson);

      expect(result, equals(userDto));
    });

    test('should correctly serialize to JSON', () {
      final result = userDto.toJson();

      expect(result, equals(testJson));
    });

    test('should correctly map to UserModel', () {
      final result = userDto.toDomain();

      expect(result, equals(userModel));
    });
  });
}
