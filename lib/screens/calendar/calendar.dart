import 'package:epilepsy_care_pmk/constants/padding_values.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: content(),
      backgroundColor: Colors.transparent,
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border:Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0)
          ),
          padding: const EdgeInsets.all(kSmallPadding),
          margin: const EdgeInsets.all(kLargePadding),
          child: TableCalendar(
            calendarStyle: CalendarStyle(
            
            ),
            calendarBuilders: CalendarBuilders(),
            focusedDay: today,
            rowHeight: 50,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            firstDay: DateTime.utc(2020, 1, 14),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
          ),
        ),
      ],
    );
  }
}




//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Calendar")),
//       body: content(),
//     );
//   }

