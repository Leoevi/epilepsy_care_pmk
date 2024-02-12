import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar_and_list.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication_entry.dart';
import 'package:flutter/material.dart';

import 'medication_detail.dart';


class Medication extends StatelessWidget {
  const Medication({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBarAndList(
        title: "ข้อมูลชนิดของยา",
        iconLabelDetailButtonList: [
          for (MedicationEntry entry in medicationEntries)
            IconLabelDetailButton(icon: entry.picture, label: entry.name, onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MedicationDetail(name: entry.name, picture: entry.picture, sideEffects: entry.sideEffects, dangerSideEffects: entry.dangerSideEffects,
                      )));
            },)
        ]);
  }
}
