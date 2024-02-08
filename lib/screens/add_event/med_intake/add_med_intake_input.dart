import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class addMedTake extends StatefulWidget {
  const addMedTake({super.key});

  @override
  State<addMedTake> createState() => _addMedTakeState();
}

class _addMedTakeState extends State<addMedTake> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(
      title: "บันทึกปริมาณยา",
    );
  }
}
