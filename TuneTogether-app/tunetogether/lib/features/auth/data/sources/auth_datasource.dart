import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/helper_functions.dart';

class AuthDatasource {
  final Logger logger;

  AuthDatasource({
    required this.logger,
  });

  Future<DataState<Map<String, dynamic>>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Signing up user...');

      final jsonBody = jsonEncode({
        "name": username,
        "email": email,
        "password": password,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/register'),
        body: jsonBody,
      );

      if (response.statusCode != 201) {
        return DataFailure(
          getErrorMessage(response.statusCode),
          response.statusCode,
        );
      }

      logger.i('User signed up');
      final Map<String, dynamic> userBody = jsonDecode(response.body);
      final Map<String, dynamic> user = userBody['data'];

      return DataSuccess(user, 'User signed up');
    } catch (e) {
      logger.e(e.toString());
      if (e is SocketException || e is TimeoutException) {
        return DataFailure('Network error: $e', -1);
      }
      return DataFailure('Unknown error: $e', -1);
    }
  }

  Future<DataState<Map<String, dynamic>?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Authenticating in user...');

      final jsonBody = jsonEncode({
        "email": email,
        "password": password,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/authenticate'),
        body: jsonBody,
      );

      if (response.statusCode != 200) {
        return DataFailure(
          getErrorMessage(response.statusCode),
          response.statusCode,
        );
      }

      logger.i('User signed in');
      final Map<String, dynamic> userBody = jsonDecode(response.body);
      final Map<String, dynamic> user = userBody['data'];

      return DataSuccess(user, 'User signed in');
    } catch (e) {
      logger.e(e.toString());
      if (e is SocketException || e is TimeoutException) {
        return DataFailure('Network error: $e', -1);
      }
      return DataFailure('Unknown error: $e', -1);
    }
  }

  // Future<DataState<String, String>> authWithGoogle({
  //   required String phone,
  // }) async {}

  // Future<DataState<String, String>> verifyPhoneNumber({
  //   required String phone,
  // }) async {}

  // Future<DataState<String, Map<String, dynamic>>> signInWithPhoneNumber({
  //   required String phone,
  //   required String code,
  // }) async {}

  // Future<DataState<String, String>> sendPassResetOtp({
  //   required String email,
  // }) async {}

  // Future<DataState<String, String>> verifyOtp({
  //   required String code,
  //   required String email,
  // }) async {}

  // Future<DataState<String, String>> resetPass({
  //   required String email,
  //   required String password,
  // }) async {}
}
