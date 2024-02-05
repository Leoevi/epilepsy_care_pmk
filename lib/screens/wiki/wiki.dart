import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double screenEdgePadding =
        16.0; // TODO: declare this as a global thing where other screens can use the same padding value
    return Padding(
      padding: const EdgeInsets.all(screenEdgePadding),
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
                Spacer(flex: 1),  // Spacers are good for spacing with flex, but if you wanted to space with pixel, use sizedBox (like below)
              ],
            ),
          ),
          const SizedBox(height: screenEdgePadding),
          Expanded(
            // Wrap LayoutBuilder with Expanded in order to assign flex value to it
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              // From https://docs.flutter.dev/cookbook/lists/spaced-items
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  // LayoutBuilder must have a flex; otherwise, constraints.maxHeight will be Infinity
                  child: Column(  // Could change from col to Wrap if wanted to add spacing between children
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconLabelDetailButton(text: 'Item 1'),
                      IconLabelDetailButton(text: 'Item 2'),
                      IconLabelDetailButton(text: 'Item 3'),
                      IconLabelDetailButton(text: 'Item 3'),
                      IconLabelDetailButton(text: 'Item 3'),
                      IconLabelDetailButton(text: 'Item 3'),
                      IconLabelDetailButton(text: 'Item 3'),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}


