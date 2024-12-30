import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/usecase.dart';
import 'package:tunetogether/features/auth/data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignUpUsecase
    implements Usecase<DataState<UserModel>, SignUpUsecaseParams> {
  final AuthRepository authRepository;

  SignUpUsecase({required this.authRepository});

  @override
  Future<DataState<UserModel>> execute({
    required SignUpUsecaseParams params,
  }) async {
    return await authRepository.signUp(
      params.username,
      params.email,
      params.password,
    );
  }
}

class SignUpUsecaseParams {
  final String username;
  final String email;
  final String password;

  const SignUpUsecaseParams({
    required this.username,
    required this.email,
    required this.password,
  });
}
