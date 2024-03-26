import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class ScreenWithAppBarAndList extends StatelessWidget {
  const ScreenWithAppBarAndList({
    super.key,
    required this.title,
    required this.iconLabelDetailButtonList,
  });

  final String title;
  final List<IconLabelDetailButton> iconLabelDetailButtonList;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: title,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
        child: ListView.builder(
          itemCount: iconLabelDetailButtonList.length,
            itemBuilder: (context, index) => iconLabelDetailButtonList[index]
        ),
      ),
    );
  }
}
