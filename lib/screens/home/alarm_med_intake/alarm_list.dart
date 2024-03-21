import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_card_with_toggle.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/home/alarm_med_intake/add_alarm_input.dart';
import 'package:flutter/material.dart';

class AlarmMedIntake extends StatefulWidget {
  const AlarmMedIntake({super.key});

  @override
  State<AlarmMedIntake> createState() => _AlarmMedIntakeState();
}

class _AlarmMedIntakeState extends State<AlarmMedIntake> {
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
            icon: Icon(Icons.add))
      ],
      body: Padding(
          padding: EdgeInsets.all(kMediumPadding),
          child: SingleChildScrollView(
              child: Column(
            children: [
              EventCardWithToggleSwitch(
                titleAlarm: 'Med Name',
                timeAlarm: '9.00 น.',
                detailAlarm:
                    'detaildetaildetaildetaildetaildetaildetaildetaildetaildetail',
              ),
              EventCardWithToggleSwitch(
                titleAlarm: 'Med Name',
                timeAlarm: '9.00 น.',
                detailAlarm:
                    'detaildetaildetaildetaildetaildetaildetaildetaildetaildetail',
              ),
              EventCardWithToggleSwitch(
                titleAlarm: 'Med Name',
                timeAlarm: '9.00 น.',
                detailAlarm:
                    'detaildetaildetaildetaildetaildetaildetaildetaildetaildetail',
              ),
              EventCardWithToggleSwitch(
                titleAlarm: 'Med Name',
                timeAlarm: '9.00 น.',
                detailAlarm:
                    'detaildetaildetaildetaildetaildetaildetaildetaildetaildetail',
              ),
            ],
          ))),
    );
  }
}
