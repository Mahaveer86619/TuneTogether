import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/common/helpers/helper_functions.dart';

class HomeRemoteSource {
  final Logger logger;

  HomeRemoteSource({required this.logger});

  // get joined groups
  // get public groups
  // get user details by id

  Future<DataState<Map<String, dynamic>>> getUserDetailsByID({
    required String userId,
    required String token,
  }) async {
    try {
      logger.i('Getting user details by ID');

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users?id=$userId'),
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

      final Map<String, dynamic> data = jsonDecode(response.body);

      return DataSuccess(
        data,
        'User details fetched',
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

  Future<DataState<List<Map<String, dynamic>>>> getJoinedGroups({
    required List<String> groupIds,
    required String token,
  }) async {
    try {
      logger.i('Getting joined groups');

      List<Map<String, dynamic>> joinedGroupDetails = [];

      // Iterate over group IDs and fetch their details
      for (String groupId in groupIds) {
        final groupDetailsResponse = await getGroupDetailsByID(
          groupId: groupId,
          token: token,
        );

        if (groupDetailsResponse is DataSuccess<Map<String, dynamic>>) {
          joinedGroupDetails.add(groupDetailsResponse.data!);
        } else if (groupDetailsResponse is DataFailure) {
          // Log the failure and continue
          logger.e('Failed to fetch details for groupId: $groupId, '
              'Reason: ${groupDetailsResponse.message}');
        }
      }

      logger.i('Fetched details for ${joinedGroupDetails.length} groups');


      return DataSuccess(
        joinedGroupDetails,
        'Joined groups fetched successfully',
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

  Future<DataState<Map<String, dynamic>>> getGroupDetailsByID({
    required String groupId,
    required String token,
  }) async {
    try {
      logger.i('Getting group details by ID');

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/groups?id=$groupId'),
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

      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> groupData = data['data'];

      return DataSuccess(
        groupData,
        'Group details fetched',
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

  
}
