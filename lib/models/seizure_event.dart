class SeizureEvent {
  // In camelCase, Acronyms are usually written with the only the first letter capitalized.
  // https://stackoverflow.com/questions/15526107/acronyms-in-camelcase
  final int? seizureId;
  final int time;
  final String seizureType;
  final String? seizureSymptom;
  final String seizurePlace;

  const SeizureEvent({
    this.seizureId,
    required this.time,
    required this.seizureType,
    this.seizureSymptom,
    required this.seizurePlace,
  });

  // We didn't actually "use json", but we just call things that
  // are in the format of "Map<String, dynamic>" that is used as a key-value pair
  // collection that represents an object as json (because that's what json is used for)
  // try looking at this https://stackoverflow.com/a/42888819
  // (about late final and whatever it wants)
  // SeizureEvent.fromJson(Map<String, dynamic> json) {
  //   this.seizureID = json["name"];
  //   this.time = json["time"];
  //   this.seizureType = json["seizureType"];
  //   this.seizureSymptom = json["seizureSymptom"];
  //   this.seizurePlace = json["seizurePlace"];
  // }
  factory SeizureEvent.fromJson(Map<String, dynamic> json) => SeizureEvent(
        seizureId: json["seizureId"],
        time: json["time"],
        seizureType: json["seizureType"],
        seizureSymptom: json["seizureSymptom"],
        seizurePlace: json["seizurePlace"],
      );

  Map<String, dynamic> toJson() => {
    "seizureId": seizureId,
    "time": time,
    "seizureType": seizureType,
    "seizureSymptom": seizureSymptom,
    "seizurePlace": seizurePlace
  };

  @override
  String toString() {
    return "SeizureEvent object with seizureID: $seizureId, time: $time, seizureType: $seizureType, seizureSymptom: $seizureSymptom, seizurePlace: $seizurePlace";
  }
}
