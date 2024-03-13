// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Pantira Chinsuwan, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:epilepsy_care_pmk/constants/styling.dart';
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
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(kSmallPadding),
          margin: const EdgeInsets.all(kLargePadding),
          child: TableCalendar(
            calendarStyle: CalendarStyle(),
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
            locale: 'en_US', //TODO: change to TH lang.
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

