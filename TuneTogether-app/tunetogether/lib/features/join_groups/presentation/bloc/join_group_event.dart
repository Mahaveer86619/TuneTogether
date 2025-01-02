part of 'join_group_bloc.dart';

sealed class JoinGroupEvent {}

final class GetPublicGroups extends JoinGroupEvent {}

final class JoinGroup extends JoinGroupEvent {}
