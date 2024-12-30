import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/usecase.dart';
import 'package:tunetogether/features/auth/data/models/user_model.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase
    implements Usecase<DataState<UserEntity>, SignInUsecaseParams> {
  final AuthRepository authRepository;

  SignInUsecase({required this.authRepository});

  @override
  Future<DataState<UserModel>> execute({
    required SignInUsecaseParams params,
  }) async {
    return await authRepository.signIn(
      params.email,
      params.password,
    );
  }
}


class SignInUsecaseParams {
  final String email;
  final String password;

  const SignInUsecaseParams({
    required this.email,
    required this.password,
  });
}
