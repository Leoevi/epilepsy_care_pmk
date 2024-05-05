import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/styling.dart';

/// Time inputting widget. Using dropdown buttons to select hours and
/// minutes respectively. This seems to be easier than the usual Flutter's
/// TimePicker dialog, so we opted to use this instead.
class TimeOfDayDropdown extends StatefulWidget {
  const TimeOfDayDropdown({
    super.key,
    required this.startingTime,
    required this.onTimeChanged,
  });

  /// A callback that triggered when a dropdown button has been selected
  final void Function(TimeOfDay) onTimeChanged;
  /// Default time that is selected when the widget is built. Usually is the current time.
  final TimeOfDay? startingTime;

  @override
  State<TimeOfDayDropdown> createState() => _TimeOfDayDropdownState();
}

class _TimeOfDayDropdownState extends State<TimeOfDayDropdown> {
  /// The currently selected hour, can be changed by choosing the dropdown button.
  late int? hour;
  /// The currently selected minute, can be changed by choosing the dropdown button.
  late int? minute;
  /// Used to add leading zeroes to hour/minutes (eg. 5 min --> 05 min)
  final formatter = NumberFormat("00");

  /// Load the starting time into the dropdown button. (if it's specified)
  @override
  void initState() {
    super.initState();
    hour = widget.startingTime?.hour;
    minute = widget.startingTime?.minute;
  }

  /// Will be called when one of the dropdown buttons is changed. And will call
  /// [onTimeChanged] if both of the fields is non-null.
  void timeChanged({int? newHour, int? newMinute}) {
    // Update the value that is changed
    if (newHour != null) {
      this.hour = newHour;  // Update with new hour
    } else if (newMinute != null) {
      this.minute = newMinute;  // Update with new minute
    }

    // Change the time if both have been selected at least once. (or a startTime was given)
    if (hour != null && minute != null) {
      widget.onTimeChanged(TimeOfDay(hour: hour!, minute: minute!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            validator: (val) {
              if (val == null) {
                return "กรุณาเลือกชั่วโมง";
              }
            },
            value: widget.startingTime?.hour,
            items: List.generate(TimeOfDay.hoursPerDay, (index) => DropdownMenuItem<int>(
              value: index,
              child: Text(formatter.format(index)),
            )),
            decoration: InputDecoration(border: OutlineInputBorder()),
            // Update with new selected hour
            onChanged: (hour) {
              timeChanged(newHour: hour);
            },
          ),
        ),
        SizedBox(width: kSmallPadding,),
        Text("นาฬิกา"),
        SizedBox(width: kSmallPadding,),
        Expanded(
          child: DropdownButtonFormField<int>(
            validator: (val) {
              if (val == null) {
                return "กรุณาเลือกนาที";
              }
            },
            value: widget.startingTime?.minute,
            items: List.generate(TimeOfDay.minutesPerHour, (index) => DropdownMenuItem<int>(
              value: index,
              child: Text(formatter.format(index)),
            )),
            decoration: InputDecoration(border: OutlineInputBorder()),
            // Update with new selected minute
            onChanged: (minute) {
              timeChanged(newMinute: minute);
            },
          ),
        ),
        SizedBox(width: kSmallPadding,),
        Text("นาที"),
      ],
    );
  }
}
