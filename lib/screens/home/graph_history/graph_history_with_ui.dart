import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar_and_white_container.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_history.dart';
import 'package:flutter/material.dart';

class GraphHistoryWithTab extends StatefulWidget {
  const GraphHistoryWithTab({super.key});

  @override
  State<GraphHistoryWithTab> createState() => _GraphHistoryWithTabState();
}

class _GraphHistoryWithTabState extends State<GraphHistoryWithTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFFF6C0FF),
              Color(0xFFF69AFF)
            ] // TODO: use colors from theme instead of hardcoding
                )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: Text("ประวัติการชักเเละกินยา")),
            body: Padding(
              padding: EdgeInsets.all(kMediumPadding),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 200),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFDAD4FF),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: TabBar(
                            indicator: BoxDecoration(
                                color: Color(0xFFFDEBED),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(text: "อาการชัก"),
                              Tab(text: "บันทึกยา")
                            ]),
                      ),
                      Expanded(
                        child: Container(
                          child: TabBarView(children: [
                            Column(
                              children: [
                                Container(
                                  child: Text("Hello"),
                                ),
                                DosageGraph(
                                  medIntakes: [
                                    MedIntakePerDay(100, DateTime(2023, 1, 5)),
                                    MedIntakePerDay(300, DateTime(2023, 1, 6)),
                                    MedIntakePerDay(300, DateTime(2023, 1, 7)),
                                    MedIntakePerDay(80, DateTime(2023, 1, 8)),
                                    MedIntakePerDay(150, DateTime(2023, 1, 9)),
                                    MedIntakePerDay(150, DateTime(2023, 1, 10)),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  child: Text("Hello"),
                                ),
                                DosageGraph(
                                  medIntakes: [
                                    MedIntakePerDay(100, DateTime(2023, 1, 5)),
                                    MedIntakePerDay(300, DateTime(2023, 1, 6)),
                                    MedIntakePerDay(300, DateTime(2023, 1, 7)),
                                    MedIntakePerDay(80, DateTime(2023, 1, 8)),
                                    MedIntakePerDay(150, DateTime(2023, 1, 9)),
                                    MedIntakePerDay(150, DateTime(2023, 1, 10)),
                                  ],
                                )
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
