import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class MedicationDetail extends StatelessWidget {
  const MedicationDetail({
    super.key,
    required this.medicationEntry,
  });

  final Medication medicationEntry;

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
                      child: Image(
                        image: medicationEntry.picture,
                      )),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        medicationEntry.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
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
                  Text("ขนาด: ${medicationEntry.medicationIntakeMethod ?? "-"}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text("ผลข้างเคียง: ${medicationEntry.sideEffects ?? "-"}"),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Text("ผลข้างเคียงที่ต้องระวัง: ${medicationEntry.dangerSideEffects ?? "-"}"),
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
