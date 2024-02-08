import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class medAllergy extends StatefulWidget {
  const medAllergy({super.key});

  @override
  State<medAllergy> createState() => _medAllergyState();
}

class _medAllergyState extends State<medAllergy> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(
      title: "บันทึกอาการเเพ้ยา",
      
    );
  }
}
