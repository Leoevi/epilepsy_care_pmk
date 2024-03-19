import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Inspired from here: https://www.youtube.com/watch?v=26TTYlwc6FM
// and here: https://pub.dev/packages/flutter_local_notifications
// TODO: Investigate why iOS not navigating to intended screen after launching with notification.
class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final _notificationTriggerController = StreamController<String?>.broadcast();
  /// Stream for letting the app know when a notification is selected.
  /// Will be subscribed to when the app initializes.
  static final notificationTriggerStream = _notificationTriggerController.stream;
  /// This method will be called to update the stream
  static void _addSelectedNotification(String? payload) {
    _notificationTriggerController.add(payload);
  }

  static Future<void> initNotification() async {
    // Ask for permission
    notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    // The app_icon.png file with the middle white part cut out with extra padding to make the line more prominent
    AndroidInitializationSettings androidInitSettings = const AndroidInitializationSettings("notification_icon");

    // Ask for permission (iOS)
    notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(
        // TODO: check if this is working for iOS < 10
          onDidReceiveLocalNotification: (id, title, body, payload) {
            _addSelectedNotification(payload);
          }
        );

    var initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      // This only works when the app is already running
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        _addSelectedNotification(notificationResponse.payload);
      },
    );

    // This is for when the app is closed
    final details = await notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _addSelectedNotification(details.notificationResponse!.payload);
    }

    // Initialize the timezone package so that we case use it to schedule notifications later
    tz.initializeTimeZones();
    String currentLocation = await FlutterTimezone.getLocalTimezone();
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

  static Future<void> scheduleNotification(
      {int id = 1,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) {
    return notificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // This required USE_EXACT_ALARM permission
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime // for iOS
        );
  }

  static Future<void> scheduleDailyNotification(
      {int id = 2,
      String? title,
      String? body,
      String? payload,
      required TimeOfDay timeOfDay}) {
    return notificationsPlugin.zonedSchedule(
        id, title, body, _scheduleDate(timeOfDay), _notificationDetails(),
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  // This required USE_EXACT_ALARM permission
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime  // for iOS
        );
  }

  static tz.TZDateTime _scheduleDate(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute, 0);

    // In case if the set notification time has already been passed, we will
    // set it on the next day instead
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future<void> cancelAll() {
    return notificationsPlugin.cancelAll();
  }
}
