import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLogo(
      child: ColumnWithSpacings(
        children: [
          IconLabelDetailButton(
              icon: Image(
                alignment: Alignment.centerLeft,
                image: AssetImage("image/header_logo_eng.png"),
              ),
              label: 'Item 1'),
          IconLabelDetailButton(label: 'Item 2'),
          IconLabelDetailButton(label: 'Item 3'),
          IconLabelDetailButton(label: 'Item 3'),
          IconLabelDetailButton(label: 'Item 3'),
          IconLabelDetailButton(label: 'Item 3'),
          IconLabelDetailButton(label: 'Item 3'),
        ],
      )
    );
  }
}
