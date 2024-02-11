import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom_detail.dart';
import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom_entry.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/icon_label_detail_button.dart';
import '../../commons/screen_with_app_bar_and_list.dart';

class Symptom extends StatelessWidget {
  const Symptom({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBarAndList(
        title: "ข้อมูลโรคอาการลมชัก",
        // Kinda like list comprehension in python (https://stackoverflow.com/questions/50441168/iterating-through-a-list-to-render-multiple-widgets-in-flutter)
        iconLabelDetailButtonList: [
          for (var entry in symptomEntries)
            IconLabelDetailButton(
                label: entry.title,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SymptomDetail(
                          title: entry.title, content: entry.content)));
                })
        ]);
  }
}
