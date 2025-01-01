part of 'home_bloc.dart';

sealed class HomeEvent {}

// get user details from remote source
class GetUserDetailsEvent extends HomeEvent {
  final String userId;

  GetUserDetailsEvent({required this.userId});
}

class GetJoinedGroupsEvent extends HomeEvent {}

class GetPublicGroupsEvent extends HomeEvent {}

// get private group by id
// func here

class JoinGroupEvent extends HomeEvent {
  final String groupId;
  final String userId;
  final String role;

  JoinGroupEvent({
    required this.groupId,
    required this.userId,
    required this.role,
  });
}
