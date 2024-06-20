import 'package:epilepsy_care_pmk/custom_widgets/dosage_graph.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_model.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/med_intake_history_print.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/page_number_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../constants/styling.dart';
import '../../../custom_widgets/time_range_dropdown_button.dart';
import '../../../models/med_intake_per_day.dart';
import '../../../services/database_service.dart';
import '../../wiki/medication/medication.dart';

class MedIntakeHistory extends StatefulWidget {
  const MedIntakeHistory({super.key});

  @override
  State<MedIntakeHistory> createState() => _MedIntakeHistoryState();
}

class _MedIntakeHistoryState extends State<MedIntakeHistory> with AutomaticKeepAliveClientMixin {
  // Extend with AutomaticKeepAliveClientMixin so that the tab won't reload when swapped.
  @override
  bool get wantKeepAlive => true;

  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  PageController medIntakePerDayPageController = PageController();
  late DateTimeRange range;

  @override
  void initState() {
    super.initState();
    range = timeRangeDropdownOption.dateTimeRange;
  }

  @override
  void dispose() {
    medIntakePerDayPageController.dispose();
    super.dispose();
  }

  Future<void> printMedIntakeHistory(
      Map<Medication, List<MedIntakePerDay>> allMedIntakePerDays) async {
    final doc = pw.Document();
    for (Medication m in allMedIntakePerDays.keys) {
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return buildPrintableMedIntakeHistory(
                m, allMedIntakePerDays[m]!, allMedIntakePerDays.keys.toList());
          }));
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    // With AutomaticKeepAlive, super.build() must be called.
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(kSmallPadding),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                // This can be optimized to not re-fetch the data from DB, but it requires using change notifier which I'm not going to bother right now.
                onPressed: () async => printMedIntakeHistory(
                    await DatabaseService.getAllMedIntakePerDayFrom(range)),
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
            // Never do "Column > Column > Expanded", that will throw the "RenderBox was not laid out" error
            // instead do "Column > Expanded/Flexible > Column > Expanded" instead
            child: FutureBuilder(
                future: DatabaseService.getAllMedIntakePerDayFrom(range),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error} $snapshot");
                      } else if (snapshot.hasData) {
                        List<Medication> medKeys = snapshot.data!.keys.toList();
                        if (medKeys.isNotEmpty) {
                          // For more info on ChangeNotifierProvider:
                          // https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifierprovider
                          // Use state management so that the PageView can change the DosageGraph state/data
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (context) => GraphModel(snapshot.data![medKeys[0]]!)),
                              ChangeNotifierProvider(create: (context) => PageNumberModel(1))
                            ],
                              // Init medIntakePerDay with content of first page
                              builder: (context, child) {
                                // Use builder instead of child, otherwise may run into Provider not found
                                return Column(
                                  children: [
                                    Flexible(
                                      // PageView must have constraint, so we wrap it in a flex widget
                                      child: PageView.builder(
                                        controller:
                                            medIntakePerDayPageController,
                                        itemCount: medKeys.length,
                                        itemBuilder: (context, index) {
                                          List<MedIntakePerDay>
                                              thisMedIntakePerDays =
                                              snapshot.data![medKeys[index]]!;
                                          double total = 0,
                                              avg = 0,
                                              max = double.negativeInfinity,
                                              min = double.infinity;
                                          for (MedIntakePerDay m
                                              in thisMedIntakePerDays) {
                                            total += m.totalDose;

                                            if (max < m.totalDose) {
                                              max = m.totalDose;
                                            }

                                            if (min > m.totalDose) {
                                              min = m.totalDose;
                                            }
                                          }
                                          avg = total /
                                              thisMedIntakePerDays.length;
                                          return MedIntakePerDayPage(
                                            medication: medKeys[index],
                                            total: total,
                                            max: max,
                                            min: min,
                                            avg: avg,
                                          );
                                        },
                                        onPageChanged: (index) {
                                          // Tell the graph that we have changed page
                                          Provider.of<GraphModel>(context,
                                                      listen: false)
                                                  .medIntakePerDays =
                                              snapshot.data![medKeys[index]]!;
                                          // Tell the page indicator the new page number
                                          Provider.of<PageNumberModel>(context, listen: false).currentPageNumber = index+1;  // +1 to correct zero-index
                                        },
                                      ),
                                      // Use PageView.builder instead because we can calculate statistic with each page's build
                                      // (TBF, you can do that even using normal PageView by moving the stats calculation to
                                      // the MedIntakePerDayPage, but I chose to roll with this for now)
                                      // PageView(
                                      //   controller: medIntakePerDayPageController,
                                      //   onPageChanged: (index) {
                                      //     // Tell the graph that we have changed page
                                      //     Provider.of<GraphModel>(context, listen: false).medIntakePerDays = snapshot.data![medKeys[index]]!;
                                      //   },
                                      //   children: [
                                      //     for (Medication med in medKeys) MedIntakePerDayPage(medication: med)
                                      //   ],
                                      // ),
                                    ),

                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF5F2FF), borderRadius: BorderRadius.vertical(bottom: Radius.circular(kSmallRoundedCornerRadius))),
                                      child: Row(
                                        children: [
                                          // https://stackoverflow.com/questions/58047009/flutter-how-to-flip-an-icon-to-get-mirror-effect
                                          IconButton(
                                            onPressed: () {
                                              medIntakePerDayPageController
                                                  .previousPage(
                                                      duration: animationDuration,
                                                      curve: Curves.easeInOut);
                                            },
                                            icon: Transform.flip(
                                                flipX: true,
                                                child:
                                                    const Icon(Icons.play_arrow)),
                                          ),
                                          Consumer<PageNumberModel>(
                                            builder: (context, model, child) {
                                              return Expanded(
                                                  child: Center(
                                                      child: Text("${model.currentPageNumber}/${medKeys.length}")));
                                            }
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              medIntakePerDayPageController
                                                  .nextPage(
                                                      duration: animationDuration,
                                                      curve: Curves.easeInOut);
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: kSmallPadding,
                                    ),

                                    // Wrap the graph with a consumer so that we can get the value from GraphModel
                                    Consumer<GraphModel>(
                                        builder: (context, model, child) {
                                      return DosageGraph(
                                          medIntakes: model.medIntakePerDays);
                                    }),
                                  ],
                                );
                              });
                        } else {
                          return const Text(
                              "ไม่มีการบันทึกประวัติการทานยาในช่วงที่เลือก");
                        }
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

class MedIntakePerDayPage extends StatelessWidget {
  final Medication medication;
  final double max, min, total, avg;

  const MedIntakePerDayPage({
    super.key,
    required this.medication,
    required this.max,
    required this.min,
    required this.total,
    required this.avg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFFF5F2FF), borderRadius: BorderRadius.vertical(top: Radius.circular(kSmallRoundedCornerRadius))),
      child: Padding(
        padding: const EdgeInsets.all(kLargePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Expanded(
                child: Text(
                  "ข้อมูลบันทึกกินยา",
                  style: mediumLargeBoldText,
                ),
              )
            ]),
            const SizedBox(
              height: kLargePadding,
            ),
            Row(children: [
              Expanded(child: Text("ชื่อยา: ${medication.name}"))
            ]),
            const SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [
              Expanded(
                  child: Text("ขนาด: ${medication.medicationIntakeMethod}"))
            ]),
            const SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [
              const Expanded(child: Text("ปริมาณยาที่ทานไปทั้งหมด")),
              Text("${total.toStringAsFixed(2)} มก."),
            ]),
            const SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [
              const Expanded(child: Text("ปริมาณยาที่ทานมากที่สุดในหนึ่งวัน")),
              Text("${max.toStringAsFixed(2)} มก."),
            ]),
            const SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [
              const Expanded(child: Text("ปริมาณยาที่ทานน้อยที่สุดในหนึ่งวัน")),
              Text("${min.toStringAsFixed(2)} มก."),
            ]),
            const SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [
              const Expanded(child: Text("ปริมาณยาที่ทานโดยเฉลี่ย")),
              Text("${avg.toStringAsFixed(2)} มก./วัน"),
            ]),
          ],
        ),
      ),
    );
  }
}
