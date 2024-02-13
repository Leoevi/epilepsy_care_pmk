import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key,
      required this.time,
      required this.title, // The button must have a header label
      required this.detail,
      required this.colorWarningIcon,
      required this.place,
      required this.type});

  final String type;
  final String place;
  final String time;
  final String title;
  final String detail;
  final Color colorWarningIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(kLargePadding),
        child: Row(children: [
          //Time
          Padding(padding: EdgeInsets.all(kMediumPadding), child: Text(time)),
          //Vertical Line
          Opacity(
            opacity: 0.5,
            child: SizedBox(
              width: 40,
              height: 125,
              child: VerticalDivider(
                thickness: 1,
              ),
            ),
          ),
          //Column for label and detail
          Expanded(
            //Protect Overflow Context
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //Title
                    Text(
                      title, //TODO: Make title not overflow
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons
                            .edit_outlined)), //TODO: Make edit and delete works
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.delete_outline))
                  ],
                ),
                //Detail
                Text(detail),
                SizedBox(
                  height: 10,
                ),
                //Icon Zone
                Row(
                  children: [
                    Icon(Icons.map_outlined),
                    Text(place),
                    Icon(
                      Icons.warning_rounded,
                      color: colorWarningIcon,
                    ),
                    Text(type)
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
