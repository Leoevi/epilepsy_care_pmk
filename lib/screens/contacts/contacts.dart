import 'package:flutter/material.dart';

import '../../constants/padding_values.dart';
import '../../custom_widgets/icon_label_detail_button.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Image(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("image/header_logo_eng.png"),
                    )),
                Spacer(flex: 1),
                // Spacers are good for spacing with flex, but if you wanted to space with pixel, use sizedBox (like below)
              ],
            ),
          ),
          const SizedBox(height: kLargePadding),
          Expanded(
            // Wrap LayoutBuilder with Expanded in order to assign flex value to it
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kMediumRoundedCornerRadius)
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                // From https://docs.flutter.dev/cookbook/lists/spaced-items
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    // LayoutBuilder must have a flex; otherwise, constraints.maxHeight will be Infinity
                    child: Column(  // Could change from col to Wrap if wanted to add spacing between children
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconLabelDetailButton(label: 'Item 1'),
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
            ),
          ),
        ],
      ),
    );
  }
}
