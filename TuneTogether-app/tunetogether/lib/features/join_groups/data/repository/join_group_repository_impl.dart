import 'package:logger/logger.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/home/data/models/group_model.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/join_groups/data/sources/join_groups_sources.dart';
import 'package:tunetogether/features/join_groups/domain/repository/join_group_repository.dart';

class JoinGroupRepositoryImpl implements JoinGroupRepository {
  final Logger logger;
  final JoinGroupsSources joinGroupsSources;

  JoinGroupRepositoryImpl({
    required this.logger,
    required this.joinGroupsSources,
  });

  @override
  Future<DataState<List<GroupEntity>>> getPublicGroups({
    required String token,
  }) async {
    try {
      final response = await joinGroupsSources.getPublicGroups(
        token: token,
      );

      if (response is DataFailure) {
        logger.e("failure: ${response.message}");
        return DataFailure(response.message!, -1);
      }

      if (response.data == null) {
        return DataFailure('No data found', -1);
      }

      final data = response.data;
      final groups = data!.map((group) => GroupModel.fromJson(group)).toList();
      return DataSuccess(groups, 'Public groups fetched');
    } catch (e) {
      logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  @override
  Future<DataState<GroupEntity>> joinGroup(
      {required String token,
      required String groupId,
      required String userId,
      required String role}) {
    // TODO: implement joinGroup
    throw UnimplementedError();
  }
}
