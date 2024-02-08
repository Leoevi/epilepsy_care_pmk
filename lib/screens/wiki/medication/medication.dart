import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar_and_list.dart';
import 'package:flutter/material.dart';

class Medication extends StatelessWidget {
  const Medication({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBarAndList(
        title: "ข้อมูลโรคอาการลมชัก",
        iconLabelDetailButtonList: [
          IconLabelDetailButton(label: "สาเหตุของอาการลมชัก", onTap: null),
          IconLabelDetailButton(label: "ชนิดและประเภท", onTap: null),
          IconLabelDetailButton(label: "วิธีการรักษาเบื้องต้น", onTap: null),
          IconLabelDetailButton(label: "ยาแก้อาการชัก", onTap: null),
        ]);
  }
}
