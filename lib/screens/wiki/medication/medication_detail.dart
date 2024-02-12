import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class MedicationDetail extends StatelessWidget {
  const MedicationDetail({
    super.key,
    required this.name,
    required this.picture,
    this.dosage,
    required this.sideEffects,
    required this.dangerSideEffects,
    this.allergySymptoms,
  });

  final String name;
  final ImageProvider<Object> picture;
  final String? dosage;
  final String sideEffects;
  final String dangerSideEffects;
  final String? allergySymptoms;

  // final String title;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: name,
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
                        image: picture,
                      )),
                  SizedBox(height: kMediumPadding,),
                  Align(alignment: Alignment.center, child: Text(name)),
                  SizedBox(height: 2*kMediumPadding,),
                  Text("ข้อมูลเบื้องต้น"),
                  SizedBox(height: 2*kMediumPadding,),
                  Text("ชื่อยา: ${name}"),
                  Text("ขนาด: ${dosage ?? "-"}"),
                  Text("ผลข้างเคียง: ${sideEffects ?? "-"}"),
                  Text("ผลข้างเคียงที่ต้องระวัง: ${dangerSideEffects ?? "-"}"),
                  Text("การแพ้ยา: ${allergySymptoms ?? "-"}"),  // TODO: It seems like every med has this field empty, why is it here in the first place?
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
