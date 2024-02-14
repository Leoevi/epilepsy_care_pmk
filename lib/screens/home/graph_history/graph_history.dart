import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';
class graphHistory extends StatefulWidget {
  const graphHistory({super.key});

  @override
  State<graphHistory> createState() => _graphHistoryState();
}

class _graphHistoryState extends State<graphHistory> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(title: 'graph',);
  }
}