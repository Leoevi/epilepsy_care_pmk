import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Inspired from here: https://www.youtube.com/watch?v=26TTYlwc6FM
// and here: https://pub.dev/packages/flutter_local_notifications
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
    // Ask for permission (Android)
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

  /// Returns whether or not the user have given notification permission to the
  /// app. Works only on Android and iOS, otherwise, will return false.
  ///
  /// Now, you may observe that the return type is nullable. I personally have
  /// no clue as to what scenario will null be even returned in the first place.
  static Future<bool?> getPermissionStatus() async {
    if (Platform.isAndroid) {
      // This statement will also ask for permission if applicable (The app can ask for permission twice and after that the user will have to go to the settings to enable notification themselves).
      AndroidFlutterLocalNotificationsPlugin? androidImplementation = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? isGranted = await androidImplementation?.requestNotificationsPermission();  // IDK why is this nullable tbh.
      return isGranted ?? false;
    } else if (Platform.isIOS) {
      // This statement will also ask for permission if applicable.
      var iOSImplementation = notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final bool? isGranted = await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return isGranted ?? false;
    } else {
      return false;
    }
  }

  /// Contains information related to how the notification will be displayed.
  /// Mainly, we want the notifications to group together so that multiple
  /// alarms that have the same time can display concurrently.
  ///
  /// Currently, we want notifications to be just a single group, so we'll just
  /// hardcode Android's group key and iOS's threadIdentifier for now.
  static _notificationDetails() {
    // For more info about grouping notifications
    // https://pub.dev/packages/flutter_local_notifications#grouping-notifications
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "0",
      "แจ้งเตือนการทานยา",
      importance: Importance.max,
      groupKey: "0",
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(threadIdentifier: "0");

    return const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  /// Show a notification the soonest moment possible after the method has been called.
  static Future<void> showNotification({int id = 0, String? title, String? body, String? payload}) {
    return notificationsPlugin.show(id,title,body, _notificationDetails(), payload: payload);
  }

  /// Schedule a notification to show on a specified DateTime.
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

  /// Schedule a daily notification on a given DateTime.
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

  /// Returns a special TZDateTime of the next occurrence
  /// of that daily notification.
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

  /// Cancel a notification with matching id, usually this id would be form the
  /// alarmId column in the database.
  static Future<void> cancel(int id) {
    return notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() {
    return notificationsPlugin.cancelAll();
  }
}
