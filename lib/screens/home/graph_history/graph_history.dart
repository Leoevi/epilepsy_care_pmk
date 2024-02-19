// This file is unused, but pending removal

// import 'dart:math';
// import 'package:collection/collection.dart';
// import 'package:epilepsy_care_pmk/constants/styling.dart';
//
// import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// import '../../../custom_widgets/dosage_graph.dart';
//
// class GraphHistory extends StatefulWidget {
//   const GraphHistory({super.key});
//
//   @override
//   State<GraphHistory> createState() => _GraphHistoryState();
// }
//
// class _GraphHistoryState extends State<GraphHistory> {
//   late List<MedIntakePerDay> medIntakes;
//
//   @override
//   void initState() {
//     super.initState();
//     // TODO: we would load medIntake from DB
//     // Some assumptions about the list
//     // - the list should be ordered by date from oldest to newest
//     // - there should be every day between the first and final date
//     // medIntakes = [
//     //   MedIntakePerDay(25, DateTime(2023,1,1)),
//     //   MedIntakePerDay(30, DateTime(2023,1,2)),
//     //   MedIntakePerDay(15, DateTime(2023,1,3)),
//     //   MedIntakePerDay(25, DateTime(2023,1,4)),
//     // ];
//     medIntakes = [
//       MedIntakePerDay(100, DateTime(2023,1,5)),
//       MedIntakePerDay(300, DateTime(2023,1,6)),
//       MedIntakePerDay(300, DateTime(2023,1,7)),
//       MedIntakePerDay(80, DateTime(2023,1,8)),
//       MedIntakePerDay(150, DateTime(2023,1,9)),
//       MedIntakePerDay(150, DateTime(2023,1,10)),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // title: 'graph',
//       body: Column(
//         children: [
//           Text("ปริมาณยา (mg)"),
//           DosageGraph(medIntakes: medIntakes,),
//         ],
//       ),
//     );
//   }
// }
//
