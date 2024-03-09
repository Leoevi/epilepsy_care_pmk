/// A class representing a point on the graph like so: (DateTime, mg)
class MedIntakePerDay {
  final double totalDose;
  final DateTime date;

  const MedIntakePerDay({required this.totalDose, required this.date});

  factory MedIntakePerDay.fromJson(Map<String, dynamic> json) => MedIntakePerDay(
    totalDose: json["totalDose"],
    date: DateTime.parse(json["date"]),  // parse String to DateTime
  );

  @override
  String toString() {
    return "$date: $totalDose";
  }
}