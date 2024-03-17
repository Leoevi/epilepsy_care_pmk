import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Inspired from here: https://www.youtube.com/watch?v=26TTYlwc6FM
// and here: https://pub.dev/packages/flutter_local_notifications
// TODO: Setup for iOS (both here and plist/manifest/whatever file
class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    // Ask for permission
    notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    // The app_icon.png file with the middle white part cut out with extra padding to make the line more prominent
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings("notification_icon");
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {},
    );

    // Initialize the timezone package so that we case use it to schedule notifications later
    tz.initializeTimeZones();
    String currentLocation = await FlutterTimezone.getLocalTimezone();
    print(currentLocation);
    print(DateTime.now().millisecondsSinceEpoch);
    print(DateTime.now().toUtc().millisecondsSinceEpoch);
    tz.setLocalLocation(tz.getLocation(currentLocation));  // set the default local time zone. Without this, all schedules are set at UTC time (+0)
  }

  static _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max)
    );
  }

  static Future<void> showNotification({int id = 0, String? title, String? body, String? payload}) {
    return notificationsPlugin.show(id,title,body, _notificationDetails(), payload: payload);
  }

  static Future<void> scheduleNotification({int id = 1, String? title, String? body, String? payload, required DateTime scheduledDate}) {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  // This required USE_EXACT_ALARM permission
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime  // for iOS
    );
  }

  static Future<void> scheduleDailyNotification({int id = 2, String? title, String? body, String? payload}) {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(TimeOfDay(hour: 8, minute: 0)),
        _notificationDetails(),
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  // This required USE_EXACT_ALARM permission
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime  // for iOS
    );
  }

  static tz.TZDateTime _scheduleDaily(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, 0);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static Future<void> cancelAll() {
    return notificationsPlugin.cancelAll();
  }
}