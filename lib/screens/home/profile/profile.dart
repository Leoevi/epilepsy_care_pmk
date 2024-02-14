import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';
class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(title: 'profile',);
  }
}