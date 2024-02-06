import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLogo(
      child: LayoutBuilder(builder: (context, constraints) {
        // From https://docs.flutter.dev/cookbook/lists/spaced-items
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            // LayoutBuilder must have a flex; otherwise, constraints.maxHeight will be Infinity
            child: Column(
              // Could change from col to Wrap if wanted to add spacing between children
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ),
          ),
        );
      }),
    );
  }
}
