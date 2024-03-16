import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationTest extends StatelessWidget {
  const NotificationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "Notification Test",
      body: Center(
        child: ElevatedButton(
          child: Text("Notification Test"),
          onPressed: () {
            NotificationService().showNotification(title: "title", body: "body");
          },
        ),
      ),
    );
  }
}
