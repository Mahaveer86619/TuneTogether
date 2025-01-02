import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/usecase.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/join_groups/domain/repository/join_group_repository.dart';

class GetPublicGroupsUsecase
    implements
        Usecase<DataState<List<GroupEntity>>, GetPublicGroupsUsecaseParams> {
  final JoinGroupRepository joinGroupRepository;

  GetPublicGroupsUsecase({required this.joinGroupRepository});

  @override
  Future<DataState<List<GroupEntity>>> execute({
    required GetPublicGroupsUsecaseParams params,
  }) async {
    return await joinGroupRepository.getPublicGroups(
      token: params.token,
    );
  }
}

class GetPublicGroupsUsecaseParams {
  final String token;

  GetPublicGroupsUsecaseParams({
    required this.token,
  });
}
