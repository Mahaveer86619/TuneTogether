import 'package:flutter/material.dart';

String prefUserKey = 'user';
String prefTokenKey = 'token';
String prefRefreshTokenKey = 'refresh_token';

String notificationChannelGroupKey = 'clearmind_notification_channel_group';
String notificationChannelGroupName =
    'clearmind_notification_channel_group_name';
String notificationChannelId = 'clearmind_notification_channel';
String notificationChannelName = 'Clearmind Notifications';
String notificationChannelDescription = 'Notifications for Clearmind';

const String defaultAvatarUrl = 'https://feji.us/a593ri';
const String defaultGroupAvatarUrl = 'https://tinyurl.com/223bcs7k';

const String baseUrl = 'http://192.168.29.150:5060';

// Group types
enum GroupTypes { public, private }

// get string from group type
String groupTypeToString(GroupTypes type) {
  switch (type) {
    case GroupTypes.public:
      return 'public';
    case GroupTypes.private:
      return 'private';
    default:
      debugPrint("Unknown group type '$type', defaulting to 'public'.");
      return 'public';
  }
}

// get group type from string
GroupTypes groupTypeFromString(String type) {
  switch (type) {
    case 'public':
      return GroupTypes.public;
    case 'private':
      return GroupTypes.private;
    default:
      debugPrint("Unknown group type '$type', defaulting to 'public'.");
      return GroupTypes.public;
  }
}
