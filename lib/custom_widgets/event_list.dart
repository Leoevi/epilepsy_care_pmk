import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/models/med_allergy_event.dart';
import 'package:epilepsy_care_pmk/models/med_intake_event.dart';
import 'package:epilepsy_care_pmk/screens/add_event/med_allergy/add_med_allergy_input.dart';
import 'package:epilepsy_care_pmk/screens/add_event/med_intake/add_med_intake_input.dart';
import 'package:flutter/material.dart';

import '../helpers/date_time_helpers.dart';
import '../models/seizure_event.dart';
import '../screens/add_event/seizure/add_seizure_input.dart';
import '../services/database_service.dart';
import 'event_card.dart';

/// A list of events displayed with the EventCard widget
class EventList extends StatefulWidget {
  /// [DateTimeRange] used to list the events within a specified range.
  /// if null, display all events in the database
  final DateTimeRange?
      dateTimeRange; // TODO: decide to include or exclude the start and the end of range

  const EventList({
    super.key,
    this.dateTimeRange,
  });

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
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
    return StreamBuilder<bool>(
        stream: DatabaseService.updateTriggerStream,
        builder: (_, __) {
          // FutureBuilder structure inspiration: https://www.youtube.com/watch?v=lkpPg0ieklg
          return FutureBuilder(
            future: widget.dateTimeRange == null ? DatabaseService.getAllSortedEvents() : DatabaseService.getAllSortedEventsFrom(widget.dateTimeRange!),
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
                    // TODO: keep scroll position after editing and deleting an entry
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          // I wanted to make use of polymorphism and define methods
                          // that returns an EventCard for each of the Event subclasses,
                          // but it is not a good practice to define methods that
                          // return Widgets. So I just resorted to define them here instead.
                          if (snapshot.data![index] is SeizureEvent) {
                            SeizureEvent entry =
                            snapshot.data![index] as SeizureEvent;
                            return EventCard(
                              time: unixTimeToDateTime(entry.time),
                              title: entry.seizureType,
                              detail: entry.seizureSymptom,
                              colorWarningIcon: Colors.red,
                              place: entry.seizurePlace,
                              type: "อาการชัก",
                              onEdit: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddSeizureInput(
                                        initSeizureEvent: entry)));
                              },
                              onDelete: () {
                                DatabaseService.deleteSeizureEvent(entry);
                              },
                            );
                          } else if (snapshot.data![index] is MedAllergyEvent) {
                            MedAllergyEvent entry =
                            snapshot.data![index] as MedAllergyEvent;
                            return EventCard(
                              time: unixTimeToDateTime(entry.time),
                              title: "แพ้ยา ${entry.med}",
                              detail: entry.medAllergySymptom,
                              colorWarningIcon: Colors.orange,
                              // TODO: don't display place if the entry doesn't have it
                              place: "none (remove this)",
                              type: "อาการแพ้ยา",
                              onEdit: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddMedAllergyInput(
                                        initMedAllergyEvent: entry)));
                              },
                              onDelete: () {
                                DatabaseService.deleteMedAllergyEvent(entry);
                              },
                            );
                          } else if (snapshot.data![index] is MedIntakeEvent) {
                            MedIntakeEvent entry =
                            snapshot.data![index] as MedIntakeEvent;
                            return EventCard(
                              time: unixTimeToDateTime(entry.time),
                              title: "ทานยา ${entry.med}",
                              detail: "ทานยา ${entry.med} ไป ${entry.mgAmount} มก.",
                              colorWarningIcon: Colors.black,
                              // TODO: don't display place if the entry doesn't have it
                              place: "none (remove this)",
                              type: "การทานยา",
                              onEdit: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddMedIntakeInput(
                                        initMedIntakeEvent: entry)));
                              },
                              onDelete: () {
                                DatabaseService.deleteMedIntakeEvent(entry);
                              },
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("ไม่มีเหตุการณ์ในช่วงเวลาที่กำหนด", style: mediumLargeBoldText, textAlign: TextAlign.center,),
                            Text("บันทึกเหตุการณ์ใหม่ในช่วงเวลาดังกล่าวด้วยเครื่องหมาย + ด้านล่าง หรือเลือกช่วงเวลาใหม่", textAlign: TextAlign.center,)
                          ],
                        ),
                      );
                    }
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
        });
  }
}
