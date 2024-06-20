import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    required this.selectedDate,
    this.onDateChange,
  });

  final DateTime selectedDate;

  final void Function(DateTime)? onDateChange;

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  final DatePickerController _controller =
      DatePickerController(); // To use "jumpToSelection" method

  /// Limits the date picker to be able to pick +/-45 days from widget.selectedDate,
  /// but not more than the current date.
  static const int selectableDateRange = 90;
  late final DateTime startDate;

  // Need to wait for the DatePicker to be built first so that jumpToSelection/animate can be called
  // otherwise 'DatePickerController is not attached to any DatePicker View.'
  // https://stackoverflow.com/questions/49466556/flutter-run-method-on-widget-build-complete
  @override
  void initState() {
    super.initState();

    // Make sure that the selectable date will not exceed today's date
    if (DateUtils.dateOnly(DateTime.now()).difference(widget.selectedDate).inDays >= selectableDateRange ~/ 2) {
      // fine
      startDate = widget.selectedDate.subtract(const Duration(days: selectableDateRange ~/ 2));
    } else {
      startDate = DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: selectableDateRange - 1));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _controller.animateToDate(widget.selectedDate)); // Since 5 days can be displayed at once, we want the selected one to be the center
  }

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      startDate,
      daysCount: selectableDateRange,
      height: 90,
      controller: _controller,
      initialSelectedDate: widget.selectedDate,
      selectionColor: const Color.fromARGB(255, 201, 128, 247),
      selectedTextColor: Colors.white,
      locale: locale,
      onDateChange: widget.onDateChange,
    );
  }
}
