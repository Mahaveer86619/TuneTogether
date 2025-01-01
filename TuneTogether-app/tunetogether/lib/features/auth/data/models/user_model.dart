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
    required super.status,
    required super.joinedGroups,
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      username: '',
      profilePic: '',
      status: '',
      joinedGroups: [],
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
      status: json['status'] ?? 'active',
      joinedGroups: (json['joined_groups'] is List)
          ? List<String>.from(json['joined_groups'])
          : (json['joined_groups'] is String)
              ? json['joined_groups'].split(',') // Handle comma-separated string
              : [],
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
      status: status,
      joinedGroups: joinedGroups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile_pic': profilePic,
      'status': status,
      'joined_groups': joinedGroups,
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
    status: $status,
    joinedGroups: $joinedGroups,
    token: $token, 
    refreshToken: $refreshToken, 
    }''';
  }
}
