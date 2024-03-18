import 'dart:convert';

import 'package:epilepsy_care_pmk/models/event.dart';

class MedIntakeEvent extends Event {
  final int? medIntakeId;
  @override
  final int time;
  final String med;
  /// Intake amount recorded in milligram. (Note that the user will not record
  /// with the milligram unit directly, instead we'll need to convert the units)
  /// that the user has recorded and convert them before storing that into the
  /// database.
  final double mgAmount;

  const MedIntakeEvent({
    this.medIntakeId,
    required this.time,
    required this.med,
    required this.mgAmount,
  });

  factory MedIntakeEvent.fromJson(Map<String, dynamic> json) => MedIntakeEvent(
    medIntakeId: json["medIntakeId"],
    time: json["time"],
    med: json["med"],
    mgAmount: json["mgAmount"],
  );

  Map<String, dynamic> toJson() => {
    "medIntakeId": medIntakeId,
    "time": time,
    "med": med,
    "mgAmount": mgAmount,
  };

  // https://www.freecodecamp.org/news/serialize-object-flutter
  // jsonDecode only returns a map, which we will to our object with "fromJson" method
  /// Factory for creating MedIntakeEvent objects from serialized string,
  /// intend to be used for notifications payload.
  factory MedIntakeEvent.fromSerializedString(String payload) => MedIntakeEvent.fromJson(jsonDecode(payload));

  /// Serialize the current object to json string which can then be decoded later.
  String toSerializedString() => jsonEncode(this);
}