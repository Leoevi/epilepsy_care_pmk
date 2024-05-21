import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/custom_widgets/medication_selection_form.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar_and_list.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:flutter/material.dart';

import 'medication_detail.dart';

class MedicationList extends StatelessWidget {
  /// Determine if this page is launched from the homepage or from a
  /// [MedicationSelection] widget.
  ///
  /// If it was launched from the [MedicationSelection] widget, then it expects
  /// to know what the selected medication is, and so this page will tell the
  /// next page to return that medication.
  final bool resultExpected;

  const MedicationList({
    super.key,
    required this.resultExpected,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBarAndList(
        title: "ข้อมูลชนิดของยา",
        iconLabelDetailButtonList: [
          for (Medication entry in medicationEntries)
            IconLabelDetailButton(
              icon: entry.icon,
              label: entry.name,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MedicationDetail(
                          medicationEntry: entry,
                          resultExpected: resultExpected,
                        )));
              },
            )
        ]);
  }
}
