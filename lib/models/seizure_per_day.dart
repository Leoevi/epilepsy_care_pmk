/// A class representing a point on the graph like so: (DateTime, seizureOccurence)
class SeizurePerDay {
  final int seizureOccurrence;
  final DateTime date;

  const SeizurePerDay({required this.seizureOccurrence, required this.date});

  factory SeizurePerDay.fromJson(Map<String, dynamic> json) => SeizurePerDay(
    seizureOccurrence: json["seizureOccurrence"],
    date: DateTime.parse(json["date"]),  // parse String to DateTime
  );

  @override
  String toString() {
    return "$date: $seizureOccurrence";
  }
}