import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class MedicationDetail extends StatelessWidget {
  const MedicationDetail({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(title: title);
  }
}
