import 'package:epilepsy_care_pmk/custom_widgets/seizure_occurrence_graph.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../custom_widgets/time_range_dropdown_button.dart';
import '../../../models/seizure_per_day.dart';

class SeizureHistory extends StatefulWidget {
  const SeizureHistory({super.key});

  @override
  State<SeizureHistory> createState() => _SeizureHistoryState();
}

class _SeizureHistoryState extends State<SeizureHistory> {
  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  late DateTimeRange range;

  @override
  void initState() {
    super.initState();
    range = timeRangeDropdownOption.dateTimeRange;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSmallPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TimeRangeDropdownButton(
              initialChoice: timeRangeDropdownOption,
              onChanged: (selectedRange) {
                setState(() {
                  range = selectedRange;
                });
              },
            ),
          ),
          SizedBox(height: kSmallPadding,),
          Flexible(
            child: FutureBuilder(
                future: DatabaseService.getAllSeizurePerDayFrom(range),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error} $snapshot");
                      } else if (snapshot.hasData) {
                        List<SeizurePerDay> seizurePerDays = snapshot.data!;
                        return Column(
                          children: [
                            // TODO: Aggregate stats and display them accordingly.
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
                            SeizureOccurrenceGraph(seizures: seizurePerDays),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Text("No data, but..."),
                            Text("${snapshot.data}")
                          ],
                        );
                      }
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}
