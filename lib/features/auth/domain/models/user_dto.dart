import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') required String displayName,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoX on UserDto {
  UserModel toDomain() {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
    );
  }
}
