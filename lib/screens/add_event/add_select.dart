import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/add_event/med_allergy/add_med_allergy_input.dart';
import 'package:epilepsy_care_pmk/screens/add_event/med_intake/add_med_intake_input.dart';
import 'package:epilepsy_care_pmk/screens/add_event/seizure/add_seizure_input.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class AddSelect extends StatelessWidget {
  const AddSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "บันทึก",
      body: content(),
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
                      IconLabelDetailButton(
                        label: 'บันทึกอาการลมชัก',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddSeizureInput()));
                        },
                      ),
                      IconLabelDetailButton(
                        label: 'บันทึกอาการเเพ้ยา',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const medAllergy()));
                        },
                      ),
                      IconLabelDetailButton(
                        label: 'บันทึกชนิดเเละปริมาณยา',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const addMedTake()));
                        },
                      ),
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
