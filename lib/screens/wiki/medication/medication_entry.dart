import 'package:flutter/material.dart';

class MedicationEntry {
  const MedicationEntry({
    required this.name,
    this.picture,
    this.dosage,
    required this.sideEffects,
    required this.dangerSideEffects,
    this.allergySymptoms,
  });

  final String name;
  final ImageProvider<Object>? picture;
  final String? dosage;
  final String sideEffects;
  final String dangerSideEffects;
  final String? allergySymptoms;
}

final List<MedicationEntry> medicationEntries = [
  MedicationEntry(
      name: "Carbamazepin",
      picture: AssetImage("image/medications/carbamazepin.jpg"),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
  MedicationEntry(
      name: "Carbamazepin",
      picture: AssetImage("image/medications/carbamazepin.jpg"),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
  MedicationEntry(
      name: "Carbamazepin",
      picture: AssetImage("image/medications/carbamazepin.jpg"),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
];
