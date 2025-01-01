import 'package:flutter/widgets.dart';
import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity{
  GroupModel({
    required super.id,
    required super.name,
    required super.description,
    required super.creatorId,
    required super.displayPicture,
    required super.type,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      creatorId: json['creator_id'] ?? '',
      displayPicture: json['display_picture'] ?? defaultGroupAvatarUrl,
      type: groupTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator_id': creatorId,
      'display_picture': displayPicture,
      'type': groupTypeToString(type),
    };
  }
}