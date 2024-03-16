import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Inspired from here: https://www.youtube.com/watch?v=26TTYlwc6FM
// and here: https://pub.dev/packages/flutter_local_notifications
// TODO: Setup for iOS (both here and plist/manifest/whatever file
class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
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
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max)
    );
  }

  Future<void> showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id,title,body, await notificationDetails());
  }
}