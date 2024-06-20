// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
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
import 'package:epilepsy_care_pmk/custom_widgets/event_list.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    // By default, this TableCalendar will return date that is in UTC,
    // But dateOnly method will return change that to local time. Which is what
    // the DatabaseService want.
    setState(() {
      selectedDate = DateUtils.dateOnly(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: content(),
      backgroundColor: Colors.transparent,
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kLargePadding, kSmallPadding, kLargePadding, 0
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            // padding: const EdgeInsets.all(kSmallPadding),
            // margin: const EdgeInsets.all(kLargePadding),
            child: TableCalendar(
              calendarStyle: const CalendarStyle(),
              calendarBuilders: const CalendarBuilders(),
              focusedDay: selectedDate,
              rowHeight: 40,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              firstDay: beginEpoch,
              lastDay: endDate,
              onDaySelected: _onDaySelected,
              locale: locale,
              // This will add dots to each date
              // Will be run for all dates on screen everytime we selected a date
              // eventLoader: (date) { print(date); return [true, true]; },
            ),
          ),
          Flexible(child: EventList(dateTimeRange: DateTimeRange(start: selectedDate, end: selectedDate),)),
        ],
      ),
    );
  }
}
