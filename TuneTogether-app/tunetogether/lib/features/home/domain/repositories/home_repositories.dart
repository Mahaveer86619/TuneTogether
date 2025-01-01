import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';

abstract class HomeRepository {
  Future<DataState<UserEntity>> getUserById({
    required String token,
    required String userId,
  });
  Future<DataState<List<GroupEntity>>> getJoinedGroups({
    required String token,
    required List<String> groupIds,
  });
  Future<DataState<GroupEntity>> getGroupById({
    required String token,
    required String groupId,
  });
}
