import 'package:logger/logger.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import '../models/user_model.dart';
import '../sources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final Logger logger;
  final AuthDatasource authDataSource;

  AuthRepositoryImp({required this.logger, required this.authDataSource});

  @override
  Future<DataState<UserModel>> signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await authDataSource.signUpWithEmailAndPassword(
        username: username,
        email: email,
        password: password,
      );

      if (response is DataFailure) {
        return DataFailure(response.message!, response.statusCode!);
      }

      return DataSuccess(UserModel.fromJson(response.data!), response.message!);
    } catch (e) {
      logger.e("Error: $e");
      return DataFailure('Error creating user', -1);
    }
  }

  @override
  Future<DataState<UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response is DataFailure) {
        return DataFailure(response.message!, response.statusCode!);
      }

      return DataSuccess(UserModel.fromJson(response.data!), response.message!);
    } catch (e) {
      logger.e("Error: $e");
      return DataFailure('Error fetching user', -1);
    }
  }

  @override
  Future<DataState<UserModel>> googleAuth() {
    // TODO: implement githubAuth
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> githubAuth() {
    // TODO: implement githubAuth
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> verifyPhone(String phone) {
    // TODO: implement verifyPhone
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> phoneAuth(String phone, String code) {
    // TODO: implement phoneAuth
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> sendPassResetOtp(String email) {
    // TODO: implement sendPassResetOtp
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> verifyOtp(String code, String email) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> resetPass(String email, String password) {
    // TODO: implement resetPass
    throw UnimplementedError();
  }
}
