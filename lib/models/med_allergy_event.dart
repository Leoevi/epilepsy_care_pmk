import 'package:epilepsy_care_pmk/models/event.dart';

class MedAllergyEvent extends Event {
  final int? medAllergyId;
  @override
  final int time;
  final String med;
  final String medAllergySymptom;

  const MedAllergyEvent({
    this.medAllergyId,
    required this.time,
    required this.med,
    required this.medAllergySymptom,
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