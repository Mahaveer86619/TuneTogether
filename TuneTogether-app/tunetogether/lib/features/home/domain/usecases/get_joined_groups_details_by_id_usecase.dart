import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/usecase.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/home/domain/repositories/home_repositories.dart';

class GetJoinedGroupsDetailsByIdUsecase
    implements
        Usecase<DataState<List<GroupEntity>>,
            GetJoinedGroupsDetailsByIdUsecaseParams> {
  final HomeRepository repository;

  GetJoinedGroupsDetailsByIdUsecase({required this.repository});

  @override
  Future<DataState<List<GroupEntity>>> execute({
    required GetJoinedGroupsDetailsByIdUsecaseParams params,
  }) async {
    return repository.getJoinedGroups(
      token: params.token,
      groupIds: params.groupIds,
    );
  }
}

class GetJoinedGroupsDetailsByIdUsecaseParams {
  final List<String> groupIds;
  final String token;

  GetJoinedGroupsDetailsByIdUsecaseParams({
    required this.groupIds,
    required this.token,
  });
}
