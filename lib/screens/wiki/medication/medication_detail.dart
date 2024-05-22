import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication_list.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class MedicationDetail extends StatelessWidget {
  final Medication medicationEntry;

  /// A continuation from the [MedicationList]
  ///
  /// Determine if this page is launched from the homepage or from a
  /// [MedicationSelection] widget.
  ///
  /// If it was launched from the [MedicationSelection] widget, then it expects
  /// to know what the selected medication is, and so this page will return that
  /// medication.
  final bool resultExpected;

  const MedicationDetail(
      {super.key, required this.medicationEntry, required this.resultExpected});

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: medicationEntry.name,
      body: Padding(
        padding: const EdgeInsets.all(kLargePadding),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // https://stackoverflow.com/questions/51513429/how-to-do-rounded-corners-image-in-flutter
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kMediumRoundedCornerRadius),
                      child: FadeInImage(
                        // by the time this page is launched, the icon will
                        // already in memory, so we will use that.
                        placeholder: medicationEntry.icon,
                        image: medicationEntry.picture,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        fadeInDuration: const Duration(milliseconds: 1),
                        fadeOutDuration: const Duration(milliseconds: 1),
                      )
                  ),
                  const SizedBox(
                    height: kMediumPadding,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        medicationEntry.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                  Align(
                    alignment: Alignment.center,
                    child: resultExpected
                        ? ElevatedButton(
                            onPressed: () {
                              // https://stackoverflow.com/questions/56725216/how-to-pop-two-screens-without-using-named-routing
                              Navigator.of(context)..pop()..pop(medicationEntry);
                            }, child: Text("เลือกยานี้"))
                        : SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 2 * kMediumPadding,
                  ),
                  Text(
                    "ข้อมูลเบื้องต้น",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 2 * kMediumPadding,
                  ),
                  Text("ชื่อยา: ${medicationEntry.name}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text(
                      "ขนาด: ${medicationEntry.medicationIntakeMethod ?? "-"}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text("ผลข้างเคียง: ${medicationEntry.sideEffects ?? "-"}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text(
                      "ผลข้างเคียงที่ต้องระวัง: ${medicationEntry.dangerSideEffects ?? "-"}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text("การแพ้ยา: ${medicationEntry.allergySymptoms ?? "-"}"),
                  // TODO: It seems like every med has this field empty, why is it here in the first place?
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
