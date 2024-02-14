import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class alarmMedTake extends StatefulWidget {
  const alarmMedTake({super.key});

  @override
  State<alarmMedTake> createState() => _alarmMedTakeState();
}

class _alarmMedTakeState extends State<alarmMedTake> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(
      title: 'alarm',
    );
  }
}
