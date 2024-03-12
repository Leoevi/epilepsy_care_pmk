import 'package:epilepsy_care_pmk/custom_widgets/dosage_graph.dart';
import 'package:epilepsy_care_pmk/screens/home/graph_history/graph_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/styling.dart';
import '../../../custom_widgets/time_range_dropdown_button.dart';
import '../../../services/database_service.dart';
import '../../wiki/medication/medication.dart';

class MedIntakeHistory extends StatefulWidget {
  const MedIntakeHistory({super.key});

  @override
  State<MedIntakeHistory> createState() => _MedIntakeHistoryState();
}

class _MedIntakeHistoryState extends State<MedIntakeHistory> {
  TimeRangeDropdownOption timeRangeDropdownOption =
      TimeRangeDropdownOption.sevenDays;
  PageController medIntakePerDayPageController = PageController();
  late DateTimeRange range;
  int currentPageIndex = 0;

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
            // Never do "Column > Column > Expanded", that will throw the "RenderBox was not laid out" error
            // instead do "Column > Expanded/Flexible > Column > Expanded" instead
            child: FutureBuilder(
                future: DatabaseService.getAllMedIntakePerDayFrom(range),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error} $snapshot");
                      } else if (snapshot.hasData) {
                        List<Medication> mapKeys = snapshot.data!.keys.toList();

                        // For more info on ChangeNotifierProvider:
                        // https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifierprovider
                        // Use state management so that the PageView can change the DosageGraph state/data
                        return ChangeNotifierProvider(
                          create: (context) => GraphModel(snapshot.data![mapKeys[0]]!),  // Init medIntakePerDay with content of first page
                          builder: (context, child) {  // Use builder instead of child, otherwise may run into Provider not found
                            return Column(
                              children: [
                                Flexible(
                                  // PageView must have constraint, so we wrap it in a flex widget
                                  child: PageView(
                                    controller: medIntakePerDayPageController,
                                    onPageChanged: (index) {
                                      // Tell the graph that we have changed page
                                      Provider.of<GraphModel>(context, listen: false).medIntakePerDays = snapshot.data![mapKeys[index]]!;
                                    },
                                    children: [
                                      for (Medication med in mapKeys) MedIntakePerDayPage(medication: med)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    // https://stackoverflow.com/questions/58047009/flutter-how-to-flip-an-icon-to-get-mirror-effect
                                    IconButton(
                                      onPressed: () {
                                        medIntakePerDayPageController.previousPage(duration: animationDuration, curve: Curves.easeInOut);
                                      },
                                      icon: Transform.flip(flipX: true, child: Icon(Icons.play_arrow)),
                                    ),
                                    Expanded(
                                        child: Center(child: Text("Page Count"))
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        medIntakePerDayPageController.nextPage(duration: animationDuration, curve: Curves.easeInOut);
                                      },
                                      icon: Icon(Icons.play_arrow),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: kSmallPadding,),

                                // Wrap the graph with a consumer so that we can get the value from GraphModel
                                Consumer<GraphModel>(
                                    builder: (context, graph, child) {
                                      return DosageGraph(medIntakes: graph.medIntakePerDays);
                                    }
                                ),
                              ],
                            );
                          }
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
                }),
          ),
        ],
      ),
    );
  }
}

class MedIntakePerDayPage extends StatelessWidget {
  final Medication medication;

  const MedIntakePerDayPage({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF5F2FF), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(kLargePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "ข้อมูลบันทึกกินยา",
                style: mediumLargeBoldText,
              )
            ]),
            SizedBox(
              height: kLargePadding,
            ),
            Row(children: [Text("ชื่อยา: ${medication.name}")]),
            SizedBox(
              height: kSmallPadding,
            ),
            Row(children: [Text("ขนาด: ${medication.medicationIntakeMethod}")]),
          ],
        ),
      ),
    );
  }
}
