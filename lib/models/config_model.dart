import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'setting_model.dart';

class ConfigModel {
  late String? token;
  late String? firebaseToken;
  late String? deviceId;

  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late StreamController<String?> selectNotificationStream;
  late List<SettingModel> settings;

  String baseUrl = "https://trenet.com.vn";
  String url = "https://trenet.com.vn";
  String notificationUrl = "";

  late InAppWebViewController? controller;
  late PlatformJavaScriptReplyProxy? replyProxy;

  bool isOpen = true;

  ConfigModel();
}
