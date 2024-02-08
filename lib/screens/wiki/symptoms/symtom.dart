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
          IconLabelDetailButton(label: "Carbamazepin", onTap: null),
          IconLabelDetailButton(label: "Clonazepam", onTap: null),
          IconLabelDetailButton(label: "Lamotrigine", onTap: null),
          IconLabelDetailButton(label: "Levetiracetam", onTap: null),
        ]);
  }
}
