import 'package:tunetogether/common/app_constants/app_constants.dart';

class GroupEntity {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final String displayPicture;
  final GroupTypes type;

  GroupEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.displayPicture,
    required this.type,
  });

  // To string
  @override
  String toString() {
    return '''GroupEntity(
id: $id, 
name: $name, 
description: $description, 
creatorId: $creatorId, 
displayPicture: $displayPicture, 
type: $groupTypeToString(type)
)''';
  }
}
