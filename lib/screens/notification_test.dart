import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationTest extends StatelessWidget {
  const NotificationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "Notification Test",
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              NotificationService.showNotification(title: "title", body: "body", payload: "payload test");
            },
            child: Text("Test now"),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationService.scheduleNotification(
                title: "scheduled noti",
                body: "scheduled noti body",
                scheduledDate: DateTime.now().add(Duration(seconds: 10)),
              );
            },
            child: Text("Test Schedule"),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationService.scheduleNotification(
                title: "scheduled noti xxx",
                body: "scheduled noti body xxx",
                scheduledDate: DateTime.now().add(Duration(seconds: 20)),
              );
            },
            child: Text("Test Schedule 2"),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationService.scheduleDailyNotification(title: "daily noti", body: "daily noti body", timeOfDay: TimeOfDay(hour: 8, minute: 0));
            },
            child: Text("Test Daily 8 AM"),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationService.cancelAll();
            },
            child: Text("Cancel All"),
          ),
        ]
      ),
    );
  }
}
