import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_range_dropdown_button.dart';
import 'package:epilepsy_care_pmk/models/med_intake_per_day.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/med_intake_history.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/dosage_graph.dart';

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
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                              children: [
                            //Tab 1 อาการชัก
                            Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(kSmallPadding),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [TimeRangeDropdownButton()])),
                                Container(
                                  width: 340,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF5F2FF),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: EdgeInsets.all(kLargePadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                            "ข้อมูลของอาการชัก",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(children: [
                                          Text("จำนวนครั้งที่เกิดอาการ")
                                        ]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [
                                          Text(
                                              "จำนวนครั้งที่เกิดอาการมากที่สุด")
                                        ]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [
                                          Text(
                                              "จำนวนครั้งที่เกิดอาการน้อยที่สุด")
                                        ]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [Text("ค่าเฉลี่ย")]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [Text("------")]),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),

                            //Tab 2 บันทึกยา
                            MedIntakeHistory(),
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
