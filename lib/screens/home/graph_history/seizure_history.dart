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
                        // total/max/min/avg calculation
                        // int total = seizurePerDays.fold(0, (sum, element) => sum + element.seizureOccurrence);
                        // fold is similar to reduce, but it can change type (reduce fixes the type to the same as the list)
                        // Was going to use fold, but I think one for loop is better because otherwise, we'll have to do four sets of loops.

                        // DateTime maxDate = seizurePerDays.first.date, minDate = seizurePerDays.first.date;
                        int max = -1, min = -1 >>> 1;  // make max the lowest int, and min the highest int (I was going to make max == ~(-1 >>> 1), but scrapped that because it'd not work on the web (they convert all bitwise int to unsigned ints (https://dart.dev/guides/language/numbers#bitwise-operations))
                        int total = 0;
                        for (var s in seizurePerDays) {
                          total += s.seizureOccurrence;

                          if (max < s.seizureOccurrence) {
                            max = s.seizureOccurrence;
                            // maxDate = s.date;
                          }

                          if (min > s.seizureOccurrence) {
                            min = s.seizureOccurrence;
                            // minDate = s.date;
                          }
                        }
                        double avg = total/seizurePerDays.length;

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
                                        style: mediumLargeBoldText,
                                      )
                                    ]),
                                    SizedBox(
                                      height: kLargePadding,
                                    ),
                                    Row(children: [
                                      Expanded(child: Text("จำนวนครั้งที่เกิดอาการทั้งหมด")),
                                      Text("$total ครั้ง"),
                                    ]),
                                    SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                            "จำนวนครั้งที่เกิดอาการมากที่สุด"),
                                      ),
                                      Text("$max ครั้ง")
                                    ]),
                                    SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                            "จำนวนครั้งที่เกิดอาการน้อยที่สุด"),
                                      ),
                                      Text("$min ครั้ง")
                                    ]),
                                    SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                            "ค่าเฉลี่ย"),
                                      ),
                                      Text("${avg.toStringAsFixed(2)} ครั้ง/วัน")
                                    ]),
                                    SizedBox(
                                      height: kSmallPadding,
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
