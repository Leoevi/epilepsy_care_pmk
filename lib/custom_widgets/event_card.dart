// This file only serves as a example and will be deleted soon

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key,
      required this.time,
      required this.title, // The button must have a header label
      this.detail,
      required this.colorWarningIcon,
      required this.place,
      required this.type});

  final String type;
  final String place;
  final DateTime time;
  final String title;
  final String? detail;
  final Color colorWarningIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: IntrinsicHeight(
          // Wrap with IntrinsicHeight so that we can see the VerticalDivider (https://stackoverflow.com/questions/49388281/flutter-vertical-divider-and-horizontal-divider)
          child: Row(children: [
            //Time
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  dateTimeDateFormat.format(time),
                  style: mediumLargeBoldText,
                ))),
            //Vertical Line
            Opacity(
              opacity: 0.5,
              child: VerticalDivider(
                thickness: 1,
              ),
            ),
            //Column for label and detail
            Expanded(
              //Protect Overflow Context
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //Title
                      Expanded(
                        child: Text(
                          title,
                          style:
                              mediumLargeBoldText,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                          onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                      //TODO: Make edit and delete works
                      IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {}, icon: Icon(Icons.delete_outline))
                    ],
                  ),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Detail
                  Text(detail ?? ""),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Icon Zone
                  Row(
                    children: [
                      Icon(Icons.map_outlined),
                      Text(place),
                      SizedBox(width: kSmallPadding,),
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
      ),
    );
  }
}
