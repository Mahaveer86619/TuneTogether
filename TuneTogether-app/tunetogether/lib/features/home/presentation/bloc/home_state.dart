part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

// loading state
final class HomeLoading extends HomeState {}

// user details loaded but joined groups are still loading
final class HomeJoinedGroupsLoading extends HomeState {
  final UserEntity user;

  HomeJoinedGroupsLoading(this.user);
}

// public groups are loading
final class HomePublicGroupsLoading extends HomeState {}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

final class UserDetailsLoaded extends HomeState {
  final UserEntity user;

  UserDetailsLoaded(this.user);
}

final class HomeJoinedGroupsLoaded extends HomeState {
  final UserEntity user;
  final List<GroupEntity> groups;

  HomeJoinedGroupsLoaded(this.groups, this.user);
}

final class HomePublicGroupsLoaded extends HomeState {
  final List<GroupEntity> groups;

  HomePublicGroupsLoaded(this.groups);
}