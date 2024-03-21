class Alarm {
  final int? alarmId;
  final int hour;
  final int minute;
  final String med;
  final double quantity;
  final String unit;

  /// Whether this alarm has been turned on or off, but will be stored in DB as
  /// an int, which we will convert to bool in this class.
  final bool enable;

  const Alarm({
    this.alarmId,
    required this.hour,
    required this.minute,
    required this.med,
    required this.quantity,
    required this.unit,
    required this.enable,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    alarmId: json["alarmId"],
      hour: json["hour"],
      minute: json["minute"],
      med: json["med"],
      quantity: json["quantity"],
      unit: json["unit"],
      enable: json["enable"] == 1,  // from int to bool
  );

  Map<String, dynamic> toJson() => {
    "alarmId": alarmId,
    "hour": hour,
    "minute": minute,
    "med": med,
    "quantity": quantity,
    "unit": unit,
    "enable": enable ? 1 : 0,  // from bool to int
  };

  // The toggle method will be in DatabaseService class...
}