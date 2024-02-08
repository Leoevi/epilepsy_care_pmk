import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLogo(
      child: ColumnWithSpacings(
        children: [
          IconLabelDetailButton(label: 'ข้อมูลโรคอาการลมชัก', detail: "เรื่องต่าง ๆ ที่ควรทราบเกี่ยวกับโรคลมชัก",onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Symptom()));
          },),
          IconLabelDetailButton(label: 'ข้อมูลชนิดของยา', detail: "ศึกษาข้อมูลของยาที่ใช้เกี่ยวกับโรคลมชักได้ที่นี่", onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Medication()));
          },),
        ],
      )
    );
  }
}
