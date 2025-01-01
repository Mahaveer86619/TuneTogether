import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/auth/data/models/user_model.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';

abstract class HomeRepositories {
  Future<DataState<GroupEntity>> getGroupById({required String groupId});
  Future<DataState<List<GroupEntity>>> getJoinedGroups({required List<String> groupIds});
  Future<DataState<UserModel>> getUserById({required String userId});
}