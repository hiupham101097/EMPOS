import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConfigModel {
  late String? token;
  late String? firebaseToken;
  late String? deviceId;

  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late StreamController<String?> selectNotificationStream;

  String notificationUrl = "";

  late InAppWebViewController? controller;
  late PlatformJavaScriptReplyProxy? replyProxy;

  bool isOpen = true;

  ConfigModel();
}
