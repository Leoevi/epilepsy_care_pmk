import 'package:flutter/material.dart';

class Alarm {
  final int? alarmId;
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
      enable: json["enable"] == 1,  // from int to bool
  );

  Map<String, dynamic> toJson() => {
    "alarmId": alarmId,
    "hour": time.hour,
    "minute": time.minute,
    "med": med,
    "quantity": quantity,
    "unit": unit,
    "enable": enable ? 1 : 0,  // from bool to int
  };

  /// Toggle the status of the alarm to the opposite. Doesn't update the
  /// database by itself.
  void toggleEnable() {
    enable = !enable;
  }

  @override
  String toString() {
    return "$alarmId, $time, $med, $quantity, $unit, $enable \n";
  }

  // The toggle method will be in DatabaseService class...
}