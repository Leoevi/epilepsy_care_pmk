import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class MedicationDetail extends StatelessWidget {
  const MedicationDetail({
    super.key,
    // required this.title,
  });

  // final String title;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "Carbamazepin",
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
                        image: AssetImage("image/medications/carbamazepin.jpg"),
                      )),
                  SizedBox(height: kMediumPadding,),
                  Align(alignment: Alignment.center, child: Text("Carbamazepin")),
                  SizedBox(height: 2*kMediumPadding,),
                  Text("ข้อมูลเบื้องต้น"),
                  SizedBox(height: 2*kMediumPadding,),
                  Text("ชื่อยา: "),
                  Text("ขนาด: "),
                  Text("ผลข้างเคียง: "),
                  Text("ผลข้างเคียงที่ต้องระวัง: "),
                  Text("การแพ้ยา: "),  // TODO: It seems like every med has this field empty, why is it here in the first place?
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
