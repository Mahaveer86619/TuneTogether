import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/usecase.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';
import 'package:tunetogether/features/home/domain/repositories/home_repositories.dart';

class GetUserDetailsUsecase
    implements Usecase<DataState<UserEntity>, GetUserDetailsUsecaseParams> {
  final HomeRepository repository;

  GetUserDetailsUsecase({required this.repository});

  @override
  Future<DataState<UserEntity>> execute({
    required GetUserDetailsUsecaseParams params,
  }) async {
    return repository.getUserById(
      userId: params.userId,
      token: params.token,
    );
  }
}

class GetUserDetailsUsecaseParams {
  final String userId;
  final String token;

  GetUserDetailsUsecaseParams({required this.userId, required this.token});
}
