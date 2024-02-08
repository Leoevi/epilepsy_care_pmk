import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom_detail.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/icon_label_detail_button.dart';
import '../../commons/screen_with_app_bar_and_list.dart';

class Symptom extends StatelessWidget {
  const Symptom({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBarAndList(
        title: "ข้อมูลโรคอาการลมชัก",
        iconLabelDetailButtonList: [
          IconLabelDetailButton(label: "สาเหตุของอาการลมชัก", onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MedicationDetail()));
          }),
          IconLabelDetailButton(label: "ชนิดและประเภท", onTap: null),
          IconLabelDetailButton(label: "วิธีการรักษาเบื้องต้น", onTap: null),
          IconLabelDetailButton(label: "ยาแก้อาการชัก", onTap: null),
        ]);
  }
}
