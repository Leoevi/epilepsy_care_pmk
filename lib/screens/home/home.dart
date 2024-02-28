import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_range_dropdown_button.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_card.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/seizure_event.dart';
import 'package:epilepsy_care_pmk/screens/add_event/seizure/add_seizure_input.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTimeRange range = DateTimeRange(start: DateUtils.dateOnly(DateTime.now()).subtract(Duration(days: 7)), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // flex: 1,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Image(
                      alignment: Alignment.centerLeft,
                      image: AssetImage("image/header_logo_eng.png"),
                    )),
                Expanded(
                  flex: 3,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Color.fromARGB(255, 142, 15, 184), width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(kSmallPadding),
                      child: Row(
                        children: [
                          //Image
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: profilePlaceholder,
                          ),
                          SizedBox(
                            width: kSmallPadding,
                          ),
                          //Name
                          Expanded(
                              child: Text(
                            "FirstName",
                            textAlign: TextAlign.justify,
                          )),
                          //Button

                          IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              icon: Icon(Icons.menu))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: kLargePadding),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
            child: Row(children: [
              Icon(
                Icons.info_rounded,
                color: Color.fromARGB(255, 0, 195, 0),
              ),
              SizedBox(
                width: kSmallPadding,
              ),
              Expanded(child: Text("เหตุการณ์ที่เกิดขึ้น", style: mediumLargeBoldText,)),
              SizedBox(
                width: kLargePadding,
              ),
              TimeRangeDropdownButton(
                initialChoice: TimeRangeDropdownOption.sevenDays,
                onChanged: (selectedRange) {
                  setState(() {
                    range = selectedRange;
                    print(range);
                  });
                },
              )
            ]),
          ),
          Flexible(
              flex: 5,
              // TODO: Find a better way to refresh the list (is nesting FutureBuilder in StreamBuilder okay?)
              // Originally, this list was just a FutureBuilder that has all the entries to display as a Future.
              // However, when an entry is added (via the add button) or an entry is edited or deleted,
              // the list doesn't update to reflect that change. So, I had to find a way to make the list
              // change on database change, that makes me resort to wrapping the whole FutureBuilder within a
              // StreamBuilder that listens to DatabaseService.updateTriggerStream.
              // The way it works is that whenever the database has been modified, the stream will send out a
              // "true" value, which will make the builder within the StreamBuilder (aka the FutureBuilder)
              // rebuilds. This works, but nesting FutureBuilder within a StreamBuilder seems redundant.
              // Maybe there is a way to make the whole thing just be only a StreamBuilder?
              child: StreamBuilder<bool>(
                  stream: DatabaseService.updateTriggerStream,
                  builder: (_, __) {
                    // FutureBuilder structure inspiration: https://www.youtube.com/watch?v=lkpPg0ieklg
                    return FutureBuilder(
                      future: DatabaseService.getAllSeizureEvents(),
                      // I know that getting the future in future builder is not a good practice, but this way, I can easily force a rebuild when the stream updated
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          case ConnectionState.done:
                          default:
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (snapshot.hasData) {
                              // TODO: Use ListView.builder instead (https://docs.flutter.dev/cookbook/lists/long-lists)
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // snapshot.data cannot be null since we just checked in if-else earlier
                                    for (SeizureEvent entry
                                        in snapshot.data! as List<SeizureEvent>)
                                      EventCard(
                                        time: unixTimeToDateTime(entry.time),
                                        title: entry.seizureType,
                                        detail: entry.seizureSymptom,
                                        colorWarningIcon: Colors.red,
                                        place: entry.seizurePlace,
                                        type: "อาการชัก",
                                        // We want the list to update after we edited it, so we will rerender the list by calling setState after the navigation finished
                                        onEdit: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddSeizureInput(
                                                          initSeizureEvent:
                                                              entry)));
                                        },
                                        onDelete: () {
                                          DatabaseService.deleteSeizureEvent(
                                              entry);
                                        },
                                      )
                                  ],
                                ),
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
                      },
                    );
                  })),
        ],
      ),
    );
  }
}
