// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_range_dropdown_button.dart';
import 'package:epilepsy_care_pmk/models/med_intake_per_day.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/med_intake_history.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/seizure_history.dart';
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
                            SeizureHistory(),

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
