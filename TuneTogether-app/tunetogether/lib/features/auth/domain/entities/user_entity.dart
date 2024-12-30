class UserEntity {
  final String id;
  final String email;
  final String username;
  final String profilePic;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePic,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePic,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  String toString() {
    return '''UserEntity{
    id: $id, 
    email: $email, 
    username: $username, 
    profilePic: $profilePic, 
    }''';
  }
}
