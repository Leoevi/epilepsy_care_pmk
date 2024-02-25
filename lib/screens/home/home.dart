import 'package:epilepsy_care_pmk/constants/styling.dart';
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
  dynamic futureData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureData = DatabaseService.getAllSeizureEvents();
  }

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
          const SizedBox(height: kLargePadding),
          Flexible(
              flex: 4,
              //standard layout
              // FutureBuilder structure inspiration: https://www.youtube.com/watch?v=lkpPg0ieklg
              // TODO: make home refresh after adding entry (currently need to rebuild widget to get update)
              child: FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
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
                                  onEdit: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddSeizureInput(
                                                    initSeizureEvent: entry)));
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
              ))
        ],
      ),
    );
  }
}

// child: Center(
//             child: Column(children: <Widget>[
//           Text(
//             "This is Home",
//             style: TextStyle(
//               color: Colors.green[900],
//               fontSize: 45,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   //get today's date
//                   firstDate: DateTime(2000),
//                   //DateTime.now() - not to allow to choose before today.
//                   lastDate: DateTime(2101));
//             },
//             child: Text("Date Picker"),
//           )
//         ])),
