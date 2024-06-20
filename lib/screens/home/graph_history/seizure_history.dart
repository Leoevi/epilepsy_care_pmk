import 'package:epilepsy_care_pmk/custom_widgets/seizure_occurrence_graph.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/seizure_history_print.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../constants/styling.dart';
import '../../../custom_widgets/time_range_dropdown_button.dart';
import '../../../models/seizure_per_day.dart';


class SeizureHistory extends StatefulWidget {
  const SeizureHistory({super.key});

  @override
  State<SeizureHistory> createState() => _SeizureHistoryState();
}

class _SeizureHistoryState extends State<SeizureHistory> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  late DateTimeRange range;

  @override
  void initState() {
    super.initState();
    range = timeRangeDropdownOption.dateTimeRange;
  }

  Future<void> printSeizureHistory(List<SeizurePerDay> seizurePerDays) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableSeizureHistory(seizurePerDays);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(kSmallPadding),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () async => printSeizureHistory(await DatabaseService.getAllSeizurePerDayFrom(range)),
                icon: const Icon(Icons.local_print_shop_outlined)),
            TimeRangeDropdownButton(
              initialChoice: timeRangeDropdownOption,
              onChanged: (selectedRange) {
                setState(() {
                  range = selectedRange;
                });
              },
            ),
          ]),
          const SizedBox(
            height: kSmallPadding,
          ),
          Flexible(
            child: FutureBuilder(
                future: DatabaseService.getAllSeizurePerDayFrom(range),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
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
                        int max = -1,
                            min = -1 >>>
                                1; // make max the lowest int, and min the highest int (I was going to make max == ~(-1 >>> 1), but scrapped that because it'd not work on the web (they convert all bitwise int to unsigned ints (https://dart.dev/guides/language/numbers#bitwise-operations))
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
                        double avg = total / seizurePerDays.length;

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F2FF),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(kLargePadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(children: [
                                      Text(
                                        "ข้อมูลของอาการชัก",
                                        style: mediumLargeBoldText,
                                      )
                                    ]),
                                    const SizedBox(
                                      height: kLargePadding,
                                    ),
                                    Row(children: [
                                      const Expanded(
                                          child: Text(
                                              "จำนวนครั้งที่เกิดอาการทั้งหมด")),
                                      Text("$total ครั้ง"),
                                    ]),
                                    const SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      const Expanded(
                                        child: Text(
                                            "จำนวนครั้งที่เกิดอาการมากที่สุด"),
                                      ),
                                      Text("$max ครั้ง")
                                    ]),
                                    const SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      const Expanded(
                                        child: Text(
                                            "จำนวนครั้งที่เกิดอาการน้อยที่สุด"),
                                      ),
                                      Text("$min ครั้ง")
                                    ]),
                                    const SizedBox(
                                      height: kSmallPadding,
                                    ),
                                    Row(children: [
                                      const Expanded(
                                        child: Text("ค่าเฉลี่ย"),
                                      ),
                                      Text(
                                          "${avg.toStringAsFixed(2)} ครั้ง/วัน")
                                    ]),
                                    const SizedBox(
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
                            const Text("No data, but..."),
                            Text("${snapshot.data}")
                          ],
                        );
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
