import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<DataState<UserModel>> signUp(
    String username,
    String email,
    String password,
  );

  Future<DataState<UserModel>> signIn(
    String email,
    String password,
  );

  Future<DataState<UserModel>> googleAuth();

  Future<DataState<UserModel>> githubAuth();

  Future<DataState<String>> verifyPhone(
    String phone,
  );

  Future<DataState<UserModel>> phoneAuth(
    String phone,
    String code,
  );

  Future<DataState<UserModel>> sendPassResetOtp(
    String email,
  );

  Future<DataState<UserModel>> verifyOtp(
    String code,
    String email,
  );

  Future<DataState<UserModel>> resetPass(
    String email,
    String password,
  );
}
