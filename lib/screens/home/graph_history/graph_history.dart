import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';
class GraphHistory extends StatefulWidget {
  const GraphHistory({super.key});

  @override
  State<GraphHistory> createState() => _GraphHistoryState();
}

class _GraphHistoryState extends State<GraphHistory> {
  @override
  Widget build(BuildContext context) {
    return const ScreenWithAppBar(title: 'graph',);
  }
}