part of 'join_group_bloc.dart';

sealed class JoinGroupState {}

final class JoinGroupInitial extends JoinGroupState {}

final class JoinGroupLoading extends JoinGroupState {}

final class PublicGroupsLoaded extends JoinGroupState {
  final List<GroupEntity> groups;

  PublicGroupsLoaded(this.groups);
}

final class JoinedGroup extends JoinGroupState {}

final class JoinGroupError extends JoinGroupState {
  final String message;

  JoinGroupError(this.message);
}
