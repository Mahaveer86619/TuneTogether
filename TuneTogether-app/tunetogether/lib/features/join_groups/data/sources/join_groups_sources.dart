import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/helper_functions.dart';

class JoinGroupsSources {
  final Logger logger;

  JoinGroupsSources({required this.logger});

  Future<DataState<List<Map<String, dynamic>>>> getPublicGroups({
    required String token,
  }) async {
    try {
      logger.i('Getting public groups');

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/groups/public'),
        headers: {
          'Authorization': "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        return DataFailure(
          getErrorMessage(response.statusCode),
          response.statusCode,
        );
      }

      if (jsonDecode(response.body)['data'] == []) {
        return DataSuccess([], 'Public groups fetched');
      } 

      final List<dynamic> data = jsonDecode(response.body)['data'];

      return DataSuccess(
        data.map((e) => e as Map<String, dynamic>).toList(),
        'Public groups fetched',
      );
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        logger.e('Network error: $error');
        return DataFailure('Network error: $error', -1);
      } else {
        logger.e('Unknown error: $error');
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  // Future<DataState<void>> joinGroup({
  //   required String token,
  //   required String groupId,
  //   required String userId,
  //   required String role,
  // }) async {
  //   try {

  //   } catch (error) {
  //     if (error is SocketException || error is TimeoutException) {
  //       logger.e('Network error: $error');
  //       return DataFailure('Network error: $error', -1);
  //     } else {
  //       logger.e('Unknown error: $error');
  //       return DataFailure('Unknown error: $error', -1);
  //     }
  //   }
  // }
}
