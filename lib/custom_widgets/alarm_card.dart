import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/home/alarm_med_intake/add_alarm_input.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../models/alarm.dart';

// Since there is only 1 type of object (Alarm) that is going to be represented
// by this widget, we will just pass in the whole Alarm object then.

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    super.key,
    required this.alarm
  });

  final Alarm alarm;

  @override
  State<AlarmCard> createState() =>
      _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(kMediumPadding, kMediumPadding, kMediumPadding, 0),
        child: IntrinsicHeight(
          // Wrap with IntrinsicHeight so that we can see the VerticalDivider (https://stackoverflow.com/questions/49388281/flutter-vertical-divider-and-horizontal-divider)
          child: Row(children: [
            //Time
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  widget.alarm.time.toString(),
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
                          "${widget.alarm.med}",
                          style: mediumLargeBoldText,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddAlarm(
                                    initAlarm: widget.alarm)));
                          },
                          icon: Icon(Icons.edit_outlined)),
                      IconButton(
                          onPressed: () {
                            DatabaseService.deleteAlarm(widget.alarm);
                          },
                          icon: Icon(Icons.delete_outline))
                    ],
                  ),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Detail
                  Text("ทานยา ${widget.alarm.med} ${widget.alarm.quantity} ${widget.alarm.unit}"),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Icon Zone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch.adaptive(
                          value: widget.alarm.enable,
                          onChanged: (_) {
                            setState(() {
                              widget.alarm.toggleEnable();
                            });
                            DatabaseService.updateAlarmEnable(widget.alarm);
                          })
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
