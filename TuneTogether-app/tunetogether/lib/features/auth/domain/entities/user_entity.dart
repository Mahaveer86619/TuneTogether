class UserEntity {
  final String id;
  final String email;
  final String username;
  final String profilePic;
  final String status;
  final List<String> joinedGroups;


  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePic,
    required this.status,
    required this.joinedGroups,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePic,
    String? status,
    List<String>? joinedGroups,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      status: status ?? this.status,
      joinedGroups: joinedGroups ?? this.joinedGroups,
    );
  }

  @override
  String toString() {
    return '''UserEntity{
    id: $id, 
    email: $email, 
    username: $username, 
    profilePic: $profilePic, 
    status: $status,
    joinedGroups: $joinedGroups
    }''';
  }
}
