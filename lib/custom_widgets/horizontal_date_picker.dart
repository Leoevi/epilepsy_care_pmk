import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({super.key});

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  @override
  Widget build(BuildContext context) {
    return DatePicker(
      //TODO: Make Selected show on center
      DateTime.now(),
      height: 90,
      initialSelectedDate: DateTime.now(),
      selectionColor: Color.fromARGB(255, 201, 128, 247),
      selectedTextColor: Colors.white,
      locale: "th_TH",
      onDateChange: (date) {
        // New date selected
        setState(() {
          // _selectedValue = date;  // TODO: try to retrieve the value back
        });
      },
    );
  }
}
