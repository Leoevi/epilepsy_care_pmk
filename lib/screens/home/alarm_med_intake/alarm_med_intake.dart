import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class AlarmMedIntake extends StatefulWidget {
  const AlarmMedIntake({super.key});

  @override
  State<AlarmMedIntake> createState() => _AlarmMedIntakeState();
}

class _AlarmMedIntakeState extends State<AlarmMedIntake> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(
      title: 'alarm',
    );
  }
}
