import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_card.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_card_with_toggle.dart';
import 'package:epilepsy_care_pmk/helpers/force_break_only_at_whitespaces.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kLargePadding),
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
                // Spacer(flex: 1),

                // SizedBox(
                //   width: 20,
                // ),

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
                            // Image radius
                            // backgroundImage: icon,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          //Name
                          Expanded(
                              child: Text(
                            "ปิยะทัศน์",
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
          Expanded(
              flex: 4, //standard layout
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // A event_list here
                    EventCardWithToggleSwitch(timeAlarm: '9:00 น' , titleAlarm: 'Title This is a test for handling long text and line breaking', detailAlarm: 'DetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetail'),
                    EventCard(
                      time: '9:00 น',
                      title:
                          'Title This is a test for handling long text and line breaking',
                      detail:
                          'DetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetail',
                      type: 'seizure',
                      place: 'home',
                      colorWarningIcon: Colors.red,
                    ),
                    EventCard(
                      time: '9:00 น',
                      title: 'Title',
                      detail:
                          'DetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetail',
                      type: 'seizure',
                      place: 'home',
                      colorWarningIcon: Colors.red,
                    ),
                    EventCard(
                      time: '9:00 น',
                      title: 'Title',
                      detail:
                          'DetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetail',
                      type: 'seizure',
                      place: 'home',
                      colorWarningIcon: Colors.red,
                    ),
                    EventCard(
                      time: '9:00 น',
                      title: 'Title',
                      detail:
                          'DetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetailDetail',
                      type: 'seizure',
                      place: 'home',
                      colorWarningIcon: Colors.red,
                    )
                  ],
                ),
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