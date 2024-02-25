import 'package:flutter/material.dart';

/// Convert from unix date time representation to [DateTime] object in Dart.
/// Unix date time is counted as "seconds since epoch".
DateTime unixTimeToDateTime(int unixTime) {
  return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
}

/// Convert from [DateTime] object in dart to unix time representation.
int dateTimeToUnixTime(DateTime dateTime) {
  // ~/ means integer division in dart
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

/// Combine [TimeOfDay] and [DateTime] object into a single [DateTime] object that
/// contain both date and time information.
///
/// Since we have separate UIs for inputting both date and time, we need to
/// combine them before inserting them into the database.
DateTime combineDateTimeWithTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour,
      timeOfDay.minute);
}

/// Separate a [DateTime] object that contains both date and time information
/// into a [DateTime] with date information, and [TimeOfDay] that contains
/// time information.
(DateTime, TimeOfDay) separateDateTimeAndTimeOfDay(DateTime dateTime) {
  return (
    DateTime(dateTime.year, dateTime.month, dateTime.day),
    TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );
}
