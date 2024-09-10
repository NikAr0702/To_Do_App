import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/notified_page.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    _configureLocalTimezone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

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
          sound: false,
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
      payload: title,
    );
  }

  // Future<void> scheduledNotification(int hours, int minutes, Task task) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Scheduled Notification',
  //     'This is a scheduled notification.',
  //     // tz.TZDateTime.now(tz.local).add(Duration(seconds: newTime)),
  //     _convertTime(hours, minutes),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //           'your_channel_id', 'your_channel_name',
  //           channelDescription: 'your_channel_description'),
  //     ),
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }
  Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    String msg;
    msg = "🔴Now your task starting⏰.";

    tz.TZDateTime scheduledDate = await _convertTime(hour, minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      "🔴${task.title}",
      task.note,
      _convertTime(hour, minutes),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: false,
          icon: 'app_icon',
          // sound: const RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
          // largeIcon: const DrawableResourceAndroidBitmap('app_icon'),
          subText: msg,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}|${task.startTime}|",
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Create a time based on the provided hour and minute
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    // If the scheduled time is before now, add a day to the schedule
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
    // try {
    //   tz.setLocalLocation(tz.getLocation(timeZone));
    // } catch (e) {
    //   // If the location is not found, set a default location
    //   tz.setLocalLocation(tz.getLocation('Asia/Madhya Pradesh'));
    // }
  }

  Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('Notification payload: $payload');
    } else {
      print('Notification Done');
    }

    Get.to(() => NotifiedPage(label: payload));
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome to Flutter"));
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:todo_app/models/task_model.dart';

// class NotifyHelper {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   initializeNotification() async {
//     await _configureLocalTimezone();

//     // Android Initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     // For on tap onSelectNotification
//     Future<void> onDidReceiveLocalNotification(
//         int id, String? title, String? body, String? payload) async {
//       // Display a dialog with the notification details
//       Get.dialog(
//         AlertDialog(
//           title: Text(title ?? 'ToDo Apps'),
//           content: Text(body ?? 'Welcome to flutter apps'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back(); // Close the dialog
//                 // You can navigate to another screen here if needed
//                 // Get.to(() => SecondScreen(payload));
//               },
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     }

//     Future<void> onSelectNotification(
//         NotificationResponse notificationResponse) async {
//       final String? payload = notificationResponse.payload;
//       if (payload != null) {
//         print('Notification payload: $payload');
//       } else {
//         print('Notification Done');
//       }
//       Get.to(() => Container(color: Colors.white));
//     }

//     // // For on tap onSelectNotification
//     // Future<void> selectNotification(String? payload) async {
//     //   if (payload == "Theme Changed") {
//     //     //going nowhere
//     //     Get.to(() => NotificationDetailPage(
//     //           label: payload,
//     //         ));
//     //   } else {
//     //     Get.to(() => NotificationDetailPage(
//     //           label: payload,
//     //         ));
//     //   }
//     // }

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onSelectNotification);
//   }

//   // Request Permissions for iOS
//   void requestIOSPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

// // // Request Permissions for Android
// //   Future<void> requestAndroidPermissions() async {
// //     // Request the required permissions
// //     Map<Permission, PermissionStatus> statuses = await [
// //       Permission.notification,
// //       Permission.scheduleExactAlarm,
// //       // Add other permissions as needed
// //     ].request();

//   //   // Check if the permissions are granted
//   //   if (statuses[Permission.notification] == PermissionStatus.granted &&
//   //       statuses[Permission.scheduleExactAlarm] == PermissionStatus.granted) {
//   //   } else {
//   //     Get.snackbar("Permission Denied",
//   //         "Please allow Notification permission from settings",
//   //         backgroundColor: Colors.redAccent, colorText: Colors.white);

//   //     // If permissions are denied, we cannot continue the app
//   //     await [
//   //       Permission.notification,
//   //       Permission.scheduleExactAlarm,
//   //     ].request();
//   //   }
//   // }

//   // Future<bool> requestScheduleExactAlarmPermission() async {
//   //   if (await Permission.scheduleExactAlarm.request().isGranted) {
//   //     // Either the permission was already granted before or the user just granted it.
//   //     return true;
//   //   } else {
//   //     await Permission.scheduleExactAlarm.isDenied.then((value) {
//   //       if (value) {
//   //         Permission.scheduleExactAlarm.request();
//   //       }
//   //     });
//   //     return false;
//   //   }
//   // }

//   // Immediate Notification
//   Future<void> displayNotification(
//       {required String title, required String body}) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//       playSound: true,
//       icon: 'app_icon',
//       sound: RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
//       largeIcon: DrawableResourceAndroidBitmap('app_icon'),
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: "$title | $body |",
//     );
//   }

//   //  Scheduled Notification
//   Future<void> scheduledNotification(int hour, int minutes, Task task) async {
//     // Future<void> scheduledNotification(int hour, int minutes, Task task) async {
//     String msg;
//     msg = "🔴Now your task starting⏰.";

//     tz.TZDateTime scheduledDate = await _convertTime(hour, minutes);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       task.id!.toInt(),
//       "🔴${task.title}",
//       task.note,
//       scheduledDate,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your channel id',
//           'your channel name',
//           channelDescription: 'your channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//           playSound: true,
//           icon: 'app_icon',
//           sound: const RawResourceAndroidNotificationSound('mixkit_urgen_loop'),
//           // largeIcon: const DrawableResourceAndroidBitmap('app_icon'),
//           subText: msg,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: "${task.title}|${task.note}|${task.startTime}|",
//     );
//   }

//   Future<void> remindNotification(int hour, int minutes, Task task) async {
//     tz.TZDateTime scheduledDate = await _convertTime(hour, minutes);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       task.id!.toInt() + 1,
//       "⚠️ Don't forget to complete your task.",
//       "At ${task.startTime}🔴${task.title}",
//       scheduledDate,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel id',
//           'channel name',
//           channelDescription: 'your channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//           playSound: true,
//           icon: 'app_icon',
//           largeIcon: const DrawableResourceAndroidBitmap('app_icon'),
//           subText: "⏰ ${task.remind} minute's remaining",
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   Future<void> cancelNotification(int notificationId) async {
//     await flutterLocalNotificationsPlugin.cancel(notificationId);
//   }

//   Future<tz.TZDateTime> _convertTime(int hour, int minutes) async {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minutes,
//     );

//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     return scheduledDate;
//   }

//   Future<void> _configureLocalTimezone() async {
//     tz.initializeTimeZones();
//     final String timeZone = await FlutterTimezone.getLocalTimezone();
//     try {
//       tz.setLocalLocation(tz.getLocation(timeZone));
//     } catch (e) {
//       // If the location is not found, set a default location
//       tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
//     }
//   }
// }
