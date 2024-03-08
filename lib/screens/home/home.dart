import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/event_list.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_range_dropdown_button.dart';
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
              child: EventList(dateTimeRange: range),
          )
        ],
      ),
    );
  }
}
