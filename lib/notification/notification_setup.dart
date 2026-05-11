import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../models/config_model.dart';
import '../models/data_value.dart';

class NotificationSetup {
  static Future<void> setupFlutterNotifications() async {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    if (config.isFlutterLocalNotificationsInitialized) {
      return;
    }

    config.channel = _getChannel();
    config.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    config.selectNotificationStream = StreamController<String?>.broadcast();

    _initNotificationSettings(
      config.flutterLocalNotificationsPlugin,
      config.selectNotificationStream,
      config.channel,
    );

    config.isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    _showNotification(
      config.flutterLocalNotificationsPlugin,
      config.channel,
      message,
    );
  }

  static void showBackgroundFlutterNotification(RemoteMessage message) async {
    var channel = _getChannel();

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var selectNotificationStream = StreamController<String?>.broadcast();

    _initNotificationSettings(
      flutterLocalNotificationsPlugin,
      selectNotificationStream,
      channel,
    );

    _showNotification(flutterLocalNotificationsPlugin, channel, message);
  }

  static Future<void> requestPermissions() async {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          config.flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
    } else {
      await config.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> configureSelectNotification() async {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    config.selectNotificationStream.stream.listen((String? payload) async {
      if (payload != null && payload != "") {
        config.notificationUrl = payload;
      }
    });
  }

  static Future<void> initCurrentNotificationPayload() async {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    var notificationAppLaunchDetails = await config
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      var notificationResponse =
          notificationAppLaunchDetails.notificationResponse;

      if (notificationResponse != null) {
        var payload =
            notificationAppLaunchDetails.notificationResponse?.payload;

        if (payload != null && payload.isNotEmpty) {
          config.url = payload;
        }
      }
    }
  }

  static Future<void> _initNotificationSettings(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    StreamController<String?> selectNotificationStream,
    AndroidNotificationChannel channel,
  ) async {
    /// A notification action which triggers a App navigation event
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // final List<DarwinNotificationCategory> darwinNotificationCategories =
    //     <DarwinNotificationCategory>[
    //   DarwinNotificationCategory(
    //     "plainCategory",
    //     actions: <DarwinNotificationAction>[
    //       DarwinNotificationAction.text(
    //         'text',
    //         'Action',
    //         buttonTitle: 'Send',
    //         placeholder: 'Placeholder',
    //       ),
    //     ],
    //   ),
    // ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          //notificationCategories: darwinNotificationCategories,
        );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            switch (notificationResponse.notificationResponseType) {
              case NotificationResponseType.selectedNotification:
                selectNotificationStream.add(notificationResponse.payload);
                break;
              case NotificationResponseType.selectedNotificationAction:
                if (notificationResponse.actionId == "plainCategory") {
                  selectNotificationStream.add(notificationResponse.payload);
                }
                break;
            }
          },
    );
  }

  static AndroidNotificationChannel _getChannel() {
    return AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
  }

  static void _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel channel,
    RemoteMessage message, {
    String? title,
  }) {
    RemoteNotification? notification = message.notification;

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        );

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(categoryIdentifier: "plainCategory");

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      var data = DataValue.fromJson(message.data);
      if (notification != null) {
        data.title = notification.title ?? data.title;
        data.body = notification.body ?? data.body;
      }

      flutterLocalNotificationsPlugin.show(
        0,
        title ?? data.title,
        data.body,
        notificationDetails,
        payload: data.value,
      );
    }
  }
}



//  flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();


