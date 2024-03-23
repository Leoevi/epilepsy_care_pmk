import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/alarm_card.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_list.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/home/alarm_med_intake/add_alarm_input.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:flutter/material.dart';

/// This page took most inspirations from the [EventList] widget.
/// Where we used a StreamBuilder to force a rebuild when the database is
/// modified.
class AlarmMedIntake extends StatefulWidget {
  const AlarmMedIntake({super.key});

  @override
  State<AlarmMedIntake> createState() => _AlarmMedIntakeState();
}

class _AlarmMedIntakeState extends State<AlarmMedIntake> {
  late Future<bool?> notificationPermission;

  @override
  void initState() {
    super.initState();
    notificationPermission = NotificationService.getPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: 'ตั้งเวลากินยา',
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddAlarm()));
            },
            icon: const Icon(Icons.add))
      ],
      body: FutureBuilder<bool?>(
        future: notificationPermission,
        builder: (context, snapshot) {
          // TODO: use the acquired permission status to display appropriate page.
          return AlarmList();
        },
      ),
    );
  }
}

/// List of [Alarm] (s) displayed with the [AlarmCard] widget.
class AlarmList extends StatefulWidget {
  const AlarmList({super.key});

  @override
  State<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: DatabaseService.updateTriggerStream,
        builder: (_, __) {
          return FutureBuilder(
            future: DatabaseService.getAllAlarm(),
            // I know that getting the future in future builder is not a good practice, but this way, I can easily force a rebuild when the stream updated
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return AlarmCard(
                            alarm: snapshot.data![index],
                          );
                        }
                    );
                  } else {
                    return Column(
                      children: [
                        Text("No data, but..."),
                        Text("${snapshot.data}")
                      ],
                    );
                  }
              }
            },
          );
        }
    );
  }
}
