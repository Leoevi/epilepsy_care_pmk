import 'package:epilepsy_care_pmk/constants/padding_values.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:flutter/material.dart';

class AddSelect extends StatelessWidget {
  const AddSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // To have a gradient background, need to wrap with container
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFFCA80F7),
            Color(0x7FCA80F7)
          ] // TODO: use colors from theme instead of hardcoding
              )),
      child: Scaffold(
        appBar: AppBar(
          title: Text("บันทึก"),
        ),
        backgroundColor: Colors.transparent,
        body: content(),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kLargePadding),
          Expanded(
            // Wrap LayoutBuilder with Expanded in order to assign flex value to it
            flex: 4,
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
                      IconLabelDetailButton(label: 'Item 1'),
                      IconLabelDetailButton(label: 'Item 2'),
                      IconLabelDetailButton(label: 'Item 3'),
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
