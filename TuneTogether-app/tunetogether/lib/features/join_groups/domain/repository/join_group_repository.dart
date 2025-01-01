import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';

abstract class JoinGroupRepository {
  Future<DataState<List<GroupEntity>>> getPublicGroups({
    required String token,
  });
  Future<DataState<GroupEntity>> joinGroup({
    required String token,
    required String groupId,
    required String userId,
    required String role,
  });
}