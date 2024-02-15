import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EventCardWithToggleSwitch extends StatefulWidget {
  const EventCardWithToggleSwitch({
    super.key,
    required this.timeAlarm,
    required this.titleAlarm, // The button must have a header label
    required this.detailAlarm,
  });

  final String timeAlarm;
  final String titleAlarm;
  final String detailAlarm;

  @override
  State<EventCardWithToggleSwitch> createState() =>
      _EventCardWithToggleSwitchState();
}

class _EventCardWithToggleSwitchState extends State<EventCardWithToggleSwitch> {
  bool isSwitched = false; //ควรประกาศตัวแปรไว้นอก widget

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(kMediumPadding),
        child: IntrinsicHeight(
          // Wrap with IntrinsicHeight so that we can see the VerticalDivider (https://stackoverflow.com/questions/49388281/flutter-vertical-divider-and-horizontal-divider)
          child: Row(children: [
            //Time
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  widget.timeAlarm,
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
                          widget.titleAlarm,
                          style: mediumLargeBoldText,
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                      //TODO: Make edit and delete works
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.delete_outline))
                    ],
                  ),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Detail
                  Text(widget.detailAlarm),
                  SizedBox(
                    height: kSmallPadding,
                  ),
                  //Icon Zone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch.adaptive(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
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
