import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';

class MedAllergyEvent {
  final int? medAllergyId;
  /// [time] stored as unix time (seconds since epoch).
  ///
  /// Can be converted to DateTime object with [unixTimeToDateTime]
  final int time;
  final String med;
  final String? medAllergySymptom;

  const MedAllergyEvent({
    this.medAllergyId,
    required this.time,
    required this.med,
    this.medAllergySymptom,
  });

  factory MedAllergyEvent.fromJson(Map<String, dynamic> json) => MedAllergyEvent(
    medAllergyId: json["medAllergyId"],
    time: json["time"],
    med: json["med"],
    medAllergySymptom: json["medAllergySymptom"],
  );

  Map<String, dynamic> toJson() => {
    "medAllergyId": medAllergyId,
    "time": time,
    "med": med,
    "medAllergySymptom": medAllergySymptom,
  };
}