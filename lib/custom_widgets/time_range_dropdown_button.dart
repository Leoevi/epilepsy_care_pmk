import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:flutter/material.dart';

enum TimeRangeDropdownOption { sevenDays, thirtyDays, ninetyDays, custom }

/// A button that brings up a dropdown menu of time ranges from the last
/// 7 days/30 days/90 days or any custom date ranges using the
/// "showDateRangePicker" function.
class TimeRangeDropdownButton extends StatefulWidget {
  /// A callback function that will get called with a new date range
  /// every time a date range from the dropdown is selected.
  /// The only cases where a new date is not returned are 1) when the user select the
  /// "custom" option and doesn't select a date range by tapping the back button
  /// or the "x" button shown by the showDateRangePicker dialog.
  /// or 2) The user doesn't tap on any dropdown buttons.
  ///
  /// Note, if onChange is null, then the DateRangePicker won't be shown.
  final Function(DateTimeRange)? onChanged;

  /// What dropdown option to show by default on first build.
  /// If null, then the button will be empty initially.
  final TimeRangeDropdownOption? initialChoice;

  const TimeRangeDropdownButton({
    super.key,
    this.initialChoice,
    this.onChanged,
  });

  @override
  State<TimeRangeDropdownButton> createState() => _TimeRangeDropdownButtonState();
}

class _TimeRangeDropdownButtonState extends State<TimeRangeDropdownButton> {
  TimeRangeDropdownOption? dropdownValue;  // Track what choice we currently selected
  TimeRangeDropdownOption? previousValue;  // Track what we have selected before the current choice

  /// Keeps track of previous choice, as to use them when users cancel custom
  /// date range selection. Will be called for most normal scenarios.
  void _updatePreviousValue(TimeRangeDropdownOption newOption) {
    previousValue = newOption;
  }

  /// Update the current selected choice and rebuild the button accordingly.
  void _updateCurrentValue(TimeRangeDropdownOption? currentOption) {
    setState(() {
      dropdownValue = currentOption;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialChoice != null) {
      dropdownValue = widget.initialChoice; // Default value on first build, doesn't require setState
      _updatePreviousValue(widget.initialChoice!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(kSmallPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TimeRangeDropdownOption>(
          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 3),
          value: dropdownValue,
          onChanged: (TimeRangeDropdownOption? newValue) {
            _updateCurrentValue(newValue);
          },
          items: [
            DropdownMenuItem(
              // The null check is so that the callback fn is accidentally called
              // when it is not given
              onTap: widget.onChanged == null ? null : () {
                widget.onChanged!(DateTimeRange(start: DateUtils.dateOnly(DateTime.now()).subtract(Duration(days: 7)), end: DateTime.now()));
                _updatePreviousValue(TimeRangeDropdownOption.sevenDays);
              },
              value: TimeRangeDropdownOption.sevenDays,
              child: Text("7 วัน"),
            ),
            DropdownMenuItem(
              onTap: widget.onChanged == null ? null : () {
                widget.onChanged!(DateTimeRange(start: DateUtils.dateOnly(DateTime.now()).subtract(Duration(days: 30)), end: DateTime.now()));
                _updatePreviousValue(TimeRangeDropdownOption.thirtyDays);
              },
              value: TimeRangeDropdownOption.thirtyDays,
              child: Text("30 วัน"),
            ),
            DropdownMenuItem(
              onTap: widget.onChanged == null ? null : () {
                widget.onChanged!(DateTimeRange(start: DateUtils.dateOnly(DateTime.now()).subtract(Duration(days: 90)), end: DateTime.now()));
                _updatePreviousValue(TimeRangeDropdownOption.ninetyDays);
              },
              value: TimeRangeDropdownOption.ninetyDays,
              child: Text("90 วัน"),
            ),
            DropdownMenuItem(
              onTap: widget.onChanged == null ? null : () async {
                DateTimeRange? customRange;

                // Originally, this line was going to be sth like
                // customRange = await showDateRangePicker(context: context, firstDate: beginEpoch, lastDate: DateTime.now());
                // The problem here is that, when a DropdownMenuItem is tapped, the Navigator will attempt to pop the while dropdown menu
                // but when we called showDateRangePicker, the Navigator will attempt to push the DateRangePicker.
                // This causes a conflict where the navigator will try to do both of that at the same time and
                // result in an assertion error.
                // This can be fixed by separating the respective pop and push by using Future.delayed of zero duration.
                // As this will make "dart schedule the call as soon as possible once the current call stack returns to the event loop"
                // For more in-depth info: https://stackoverflow.com/a/55622474)
                await Future.delayed(Duration.zero,
                        () async {
                  customRange = await showDateRangePicker(context: context, firstDate: beginEpoch, lastDate: DateTime.now());
                });

                if (customRange != null) {
                  widget.onChanged!(customRange!);
                  _updatePreviousValue(TimeRangeDropdownOption.custom);
                } else {
                  // go back to previous choice
                  _updateCurrentValue(previousValue);
                }
              },
              value: TimeRangeDropdownOption.custom,
              child: Text("กำหนดเอง"),
            ),
          ],
        ),
      ),
    );
  }
}