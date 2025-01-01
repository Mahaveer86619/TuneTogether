import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/auth/data/models/user_model.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';
import 'package:tunetogether/features/home/data/models/group_model.dart';
import 'package:tunetogether/features/home/data/sources/remote_source.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/home/domain/repositories/home_repositories.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Logger logger;
  final HomeRemoteSource homeDataSource;

  HomeRepositoryImpl({
    required this.logger,
    required this.homeDataSource,
  });

  @override
  Future<DataState<GroupEntity>> getGroupById({
    required String token,
    required String groupId,
  }) async {
    try {
      final response = await homeDataSource.getGroupDetailsByID(
        token: token,
        groupId: groupId,
      );

      if (response is DataFailure) {
        logger.e("failure: ${response.message}");
        return DataFailure(response.message!, -1);
      }

      if (response.data == null) {
        return DataFailure('No data found', -1);
      }

      final data = response.data;
      final group = GroupModel.fromJson(data!);
      return DataSuccess(group, 'Group details fetched');
    } catch (e) {
      logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  @override
  Future<DataState<List<GroupEntity>>> getJoinedGroups({
    required String token,
    required List<String> groupIds,
  }) async {
    try {
      final response = await homeDataSource.getJoinedGroups(
        token: token,
        groupIds: groupIds,
      );

      if (response is DataFailure) {
        logger.e("failure: ${response.message}");
        return DataFailure(response.message!, -1);
      }

      if (response.data == null) {
        return DataFailure('No data found', -1);
      }

      final data = response.data;
      final groups = data!.map((group) => GroupModel.fromJson(group)).toList();
      return DataSuccess(groups, 'Joined groups fetched');
    } catch (e) {
      logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  @override
  Future<DataState<List<GroupEntity>>> getPublicGroups({
    required String token,
  }) async {
    try {
      final response = await homeDataSource.getPublicGroups(
        token: token,
      );

      if (response is DataFailure) {
        logger.e("failure: ${response.message}");
        return DataFailure(response.message!, -1);
      }

      if (response.data == null) {
        return DataFailure('No data found', -1);
      }

      final data = response.data;
      final groups = data!.map((group) => GroupModel.fromJson(group)).toList();
      return DataSuccess(groups, 'Public groups fetched');
    } catch (e) {
      logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  @override
  Future<DataState<UserEntity>> getUserById({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await homeDataSource.getUserDetailsByID(
        token: token,
        userId: userId,
      );

      if (response is DataFailure) {
        logger.e("failure: ${response.message}");
        return DataFailure(response.message!, -1);
      }

      if (response.data == null) {
        return DataFailure('No data found', -1);
      }

      final data = response.data!['data'];
      final user = UserModel.fromJson(data).toEntity();
      return DataSuccess(user, 'User details fetched');
    } catch (e) {
      logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }
}
