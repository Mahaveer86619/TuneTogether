import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';


class UserModel extends UserEntity {
  final String token;
  final String refreshToken;

  UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.profilePic,
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      username: '',
      profilePic: '',
      token: '',
      refreshToken: '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['name'] ?? '',
      profilePic: json['profile_pic'] ?? defaultAvatarUrl,
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      profilePic: profilePic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile_pic': profilePic,
      'token': token,
      'refresh_token': refreshToken,
    };
  }

  @override
  String toString() {
    return '''UserModel{
    id: $id, 
    email: $email, 
    username: $username, 
    profilePic: $profilePic, 
    token: $token, 
    refreshToken: $refreshToken, 
    }''';
  }
}
