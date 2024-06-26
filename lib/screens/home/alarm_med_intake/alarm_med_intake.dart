import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/alarm_card.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_list.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/home/alarm_med_intake/add_alarm_input.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:flutter/material.dart';

/// A page that is used to manage Alarms that sent out notifications at the
/// specified time. These notifications can then be selected to redirect the
/// user to [AddMedIntakeInput] with information already filled in.
class AlarmMedIntake extends StatefulWidget {
  const AlarmMedIntake({super.key});

  @override
  State<AlarmMedIntake> createState() => _AlarmMedIntakeState();
}

class _AlarmMedIntakeState extends State<AlarmMedIntake> {
  /// Determine if the app has notification permission. If not, the any
  /// subsequent alarms created will always be disabled.
  late Future<bool> notificationPermission;

  /// Aside from displaying [AlarmList], also detects notification permission
  /// and show a notice if notification permission is not available.
  @override
  void initState() {
    super.initState();
    notificationPermission = NotificationService.getPermissionStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationPermission.then((isGranted) {
        if (!isGranted) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("ไม่มีสิทธิแสดงการแจ้งเตือน"),
                  content: const Text(
                      "คุณไม่ได้ให้สิทธิแสดงการแจ้งเตือนกับแอปพลิเคชัน ทำให้การตั้งเวลาแจ้งเตือนทานยานั้นไม่สามารถทำงานได้ กรุณาให้สิทธิกับแอปพลิเคชันเพื่อให้สามารถแสดงการแจ้งเตือนได้จากการตั้งค่าอุปกรณ์ของคุณ"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("รับทราบ"))
                  ],
                );
              });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: 'ตั้งเวลาแจ้งเตือนทานยา',
      actions: <Widget>[
        FutureBuilder(
            future: notificationPermission,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.add));
                case ConnectionState.done:
                default:
                  return IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAlarmInput(
                                  isGranted: snapshot.data!,
                                )));
                      },
                      icon: const Icon(Icons.add));
              }
            }),
      ],
      body: FutureBuilder<bool>(
          future: notificationPermission,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
              default:
                return AlarmList(isGranted: snapshot.data!);
            }
          }),
    );
  }
}

/// List of [Alarm] (s) displayed with the [AlarmCard] widget.
/// Took most inspirations from the [EventList] widget
/// where we used a StreamBuilder to force a rebuild when the database is
/// modified.
class AlarmList extends StatefulWidget {
  const AlarmList({
    super.key,
    required this.isGranted,
  });

  /// A variable that will determined whether or not the notification permission
  /// has been granted, will be used to determined if the switch's onchange
  /// callback is available or not.
  final bool isGranted;

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
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return AlarmCard(
                              alarm: snapshot.data![index],
                              isGranted: widget.isGranted,
                            );
                          });
                    } else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ไม่มีการตั้งเวลาแจ้งเตือนทานยา",
                              style: mediumLargeBoldText,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "ตั้งเวลาแจ้งเตือนทานยาด้วยเครื่องหมาย +",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return Column(
                      children: [
                        const Text("No data, but..."),
                        Text("${snapshot.data}")
                      ],
                    );
                  }
              }
            },
          );
        });
  }
}
