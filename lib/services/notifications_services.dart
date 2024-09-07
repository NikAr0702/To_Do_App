import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Ensure app_icon.png is in res/drawable

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> displayNotification(
      {required String title, required String body}) async {
    print("Displaying Notification");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Theme change',
    );
  }

  Future<void> scheduledNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is a scheduled notification.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('Notification payload: $payload');
    } else {
      print('Notification Done');
    }
    Get.to(() => Container(color: Colors.white));
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome to Flutter"));
  }
}
