import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class addSeizure extends StatefulWidget {
  const addSeizure({super.key});

  @override
  State<addSeizure> createState() => _addSeizureState();
}

class _addSeizureState extends State<addSeizure> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(
      title: "บันทึกอาการลมชัก",
    );
  }
}
