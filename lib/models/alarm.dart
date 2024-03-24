import 'dart:convert';

import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:flutter/material.dart';

class Alarm {
  int? alarmId;

  /// The time that this alarm is set at. In the DB, this is actually composed
  /// of 2 columns which are hour and minute, but for convenience sake, we will
  /// just wrap this with the [TimeOfDay] class.
  final TimeOfDay time;
  final String med;
  final double quantity;
  final String unit;

  /// Whether this alarm has been turned on or off, but will be stored in DB as
  /// an int, which we will convert to bool in this class.
  bool enable;

  Alarm({
    this.alarmId,
    required this.time,
    required this.med,
    required this.quantity,
    required this.unit,
    required this.enable,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        alarmId: json["alarmId"],
        time: TimeOfDay(hour: json["hour"], minute: json["minute"]),
        med: json["med"],
        quantity: json["quantity"],
        unit: json["unit"],
        enable: json["enable"] == 1, // from int to bool
      );

  Map<String, dynamic> toJson() => {
        "alarmId": alarmId,
        "hour": time.hour,
        "minute": time.minute,
        "med": med,
        "quantity": quantity,
        "unit": unit,
        "enable": enable ? 1 : 0, // from bool to int
      };

  /// Serialize the current object to json string which can
  /// then be decoded later. This is intend to be used as notifications payload.
  String toSerializedString() => jsonEncode(this);

  // https://www.freecodecamp.org/news/serialize-object-flutter
  // jsonDecode only returns a map, which we will to our object with "fromJson" method
  /// Factory for creating Alarm objects from serialized string,
  /// intend to be used as notifications payload.
  factory Alarm.fromSerializedString(String payload) => Alarm.fromJson(jsonDecode(payload));

  /// Toggle the status of the alarm to the opposite. Doesn't update the
  /// database by itself nor schedule any notifications
  /// (use [DatabaseService.updateAlarmEnable] for those).
  void toggleEnable() {
    enable = !enable;
  }

  /// Replace null [alarmId] with a new value (from the database)
  /// Typically used after adding a new alarm to the database, since it won't
  /// have an id assigned to it yet.
  set newAlarmId(int idFromDatabase) {
    assert(alarmId == null, "alarmId should be null prior to setting it");
    alarmId = idFromDatabase;
  }

  /// Schedule notification according to the object's field.
  /// If ```enable == true```, this will schedule the notification. Otherwise,
  /// it will clear the notification.
  void setNotification() {
    // It seems like scheduling notification with the same id will override the
    // old one with the new one, and cancelling and already cancelled id doesn't
    // make any difference. Which is the behavior that we expected.
    if (enable) {
      NotificationService.scheduleDailyNotification(
          id: alarmId!,
          title: "แจ้งเตือนการทานยา",
          body: "แตะที่นี่เพื่อทำการบันทึกประวัติการทานยา $med จำนวน $quantity $unit",
          timeOfDay: time,
          payload: toSerializedString(),
      );
    } else {
      NotificationService.cancel(alarmId!);
    }
  }

  @override
  String toString() {
    return "$alarmId, $time, $med, $quantity, $unit, $enable \n";
  }
}
