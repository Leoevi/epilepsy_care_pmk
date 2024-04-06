import 'package:flutter/material.dart';

class Medication {
  const Medication({
    required this.name,
    required this.picture,
    required this.medicationIntakeMethod,
    required this.sideEffects,
    required this.dangerSideEffects,
    this.allergySymptoms,
  });

  final String name;
  final ImageProvider<Object> picture;
  final MedicationIntakeMethod medicationIntakeMethod;
  final String sideEffects;
  final String dangerSideEffects;
  final String? allergySymptoms;

  @override
  String toString() {
    return "Medication object of $name";
  }
}

/// A class that tries to describe each measurement unit of a medication
class MeasureUnit {
  MeasureUnit(this.measureName, this.measureRatio);

  /// Name of the measurement unit, e.g. pills, teaspoon, etc.
  final String measureName;

  /// The ratio of that measurement compared to the base measurement
  /// e.g. teaspoon would have the ratio of 5, because 1 teaspoon == 5 ml, etc.
  final double measureRatio;

  /// This needs overriding because otherwise the unit dropdown list will cause
  /// an assertion error because it thinks that the selected item isn't the same
  /// one as the one from the generated list.
  /// (https://stackoverflow.com/a/61257286)
  @override
  bool operator ==(dynamic other) =>
      other != null
          && other is MeasureUnit
          && measureName == other.measureName
          && measureRatio == other.measureRatio;
  /// Same reason as the [==] operator.
  @override
  int get hashCode => super.hashCode;
}

// Declaring properties in interfaces and their subclasses:
// https://stackoverflow.com/questions/65959810/dart-how-to-define-a-property-that-must-be-implemented-in-any-classes-inheriti
/// An abstract class that tries to describe how each medication
/// is taken. By itself, this is just to dictate that each method
/// must have a way to return the amount of medication taken in mg
/// but bears no implementation detail.
abstract class MedicationIntakeMethod {
  const MedicationIntakeMethod();  // IDK, but adding this line allows the subclasses to have a const constructor, so here it is

  /// List of all possible measurements for that method of intake
  abstract final List<MeasureUnit> measureList;

  /// Get the amount of meds taken in milligram
  double getMgPerUnit(MeasureUnit unit);
}
/// A class that describes medication that is pill-like, as in a discrete unit
/// of medication that can be eaten whole.
class PillMedication implements MedicationIntakeMethod {
  const PillMedication(this.mgPerPill);
  final double mgPerPill;

  // Base unit of pills are, well, pills..., and ratio of base unit is always 1
  @override
  List<MeasureUnit> get measureList => [MeasureUnit("เม็ด", 1)];

  @override
  double getMgPerUnit(MeasureUnit unit) {
    return mgPerPill*unit.measureRatio;
  }

  @override
  String toString() {
    return "${mgPerPill} mg/เม็ด";
  }
}
/// A class that describes medication that is in liquid form, which must be
/// taken in terms of millilitres, this introduces many ways to measure how much
/// the medications is taken, like a teaspoon, or a tablespoon.
class LiquidMedication implements MedicationIntakeMethod {
  const LiquidMedication(this.mgPerMl);
  final double mgPerMl;
  // This is according to metric standards
  // (US teaspoon is 4.92892159375, metric teaspoon is 5 ml)
  // https://en.wikipedia.org/wiki/Teaspoon#Unit_of_measure
  static const mlPerTeaspoon = 5;
  static const mlPerTablespoon = 3*mlPerTeaspoon;

  // Base unit of liquid is ml, so its' ratio will be 1
  // As for tsp and tbsp, this is according to metric standards
  // (US teaspoon is 4.92892159375, metric teaspoon is 5 ml)
  // https://en.wikipedia.org/wiki/Teaspoon#Unit_of_measure
  @override
  List<MeasureUnit> get measureList => [MeasureUnit("มล.", 1)];
  // List<MeasureUnit> get measureList => [MeasureUnit("ช้อนชา", 5), MeasureUnit("ช้อนโต๊ะ", 15), MeasureUnit("มล.", 1)];  // Won't use other units anymore

  @override
  double getMgPerUnit(MeasureUnit unit) {
    return mgPerMl*unit.measureRatio;
  }

  @override
  String toString() {
    return "${mgPerMl} mg/ml";
  }
}

final List<Medication> medicationEntries = [
  const Medication(
      name: "Carbamazepine / Tegretal®",
      picture: AssetImage("image/medications/drug_1.jpg"),
      medicationIntakeMethod: LiquidMedication(20),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
  const Medication(
    name: "Clonazepam / Rivotril® (0.5 mg)",
    picture: AssetImage("image/medications/drug_2.png"),
    medicationIntakeMethod: PillMedication(0.5),
    sideEffects: "อ่อนเพลีย ง่วง พฤติกรรมเปลี่ยนแปลง น้ำลายและเสมหะมาก",
    dangerSideEffects: "กดการหายใจ",
  ),  // TODO: find picture
  const Medication(
      name: "Clonazepam / Rivotril® (2 mg)",
      picture: AssetImage("image/medications/drug_2.png"),
      medicationIntakeMethod: PillMedication(2),
      sideEffects: "อ่อนเพลีย ง่วง พฤติกรรมเปลี่ยนแปลง น้ำลายและเสมหะมาก",
      dangerSideEffects: "กดการหายใจ",
  ),
  const Medication(
      name: "Lamotrigine / Lamictal® (25 mg)",
      picture: AssetImage("image/medications/drug_3.png"),
      medicationIntakeMethod: PillMedication(25),
      sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
      dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Lamotrigine / Lamictal® (50 mg)",
    picture: AssetImage("image/medications/drug_3.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),  // TODO: find picture
  const Medication(
    name: "Lamotrigine / Lamictal® (100 mg)",
    picture: AssetImage("image/medications/drug_3.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),  // TODO: find picture
  const Medication(
    name: "Levetiracetam / Keppra®",
    picture: AssetImage("image/medications/drug_4.png"),
    medicationIntakeMethod: LiquidMedication(100),
    sideEffects: "ซึม มึนงง",
    dangerSideEffects: "อารมณ์หงุดหงิด ก้าวร้าว",
  ),
  const Medication(
    name: "Oxcarbazepine / Trileptal® (300 mg)",
    picture: AssetImage("image/medications/drug_5.png"),
    medicationIntakeMethod: PillMedication(300),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "ภาวะโซเดียมต่ำ",
  ),
  const Medication(
    name: "Oxcarbazepine / Trileptal® (600 mg)",
    picture: AssetImage("image/medications/drug_5.png"),
    medicationIntakeMethod: PillMedication(600),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "ภาวะโซเดียมต่ำ",
  ),  // TODO: find picture
  const Medication(
    name: "Phenobarbital (30 mg)",
    picture: AssetImage("image/medications/drug_6.png"),
    medicationIntakeMethod: PillMedication(30),
    sideEffects: "เด็ก: ซุกซนไม่อยู่สุข พฤติกรรมเปลี่ยนแปลง ก้าวร้าว ผู้ใหญ่: ง่วงซึม อ่อนเพลีย",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),  // TODO: find picture
  const Medication(
    name: "Phenobarbital (60 mg)",
    picture: AssetImage("image/medications/Phenobarbital60.png"),
    medicationIntakeMethod: PillMedication(60),
    sideEffects: "เด็ก: ซุกซนไม่อยู่สุข พฤติกรรมเปลี่ยนแปลง ก้าวร้าว ผู้ใหญ่: ง่วงซึม อ่อนเพลีย",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Phenytoin / Dilantin® (125 mg/5 ml)",
    picture: AssetImage("image/medications/drug_7.png"),
    medicationIntakeMethod: LiquidMedication(25),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),
  const Medication(
    name: "Phenytoin / Dilantin® (50 mg)",
    picture: AssetImage("image/medications/drug_7.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),  // TODO: find picture
  const Medication(
    name: "Phenytoin / Dilantin® (100 mg)",
    picture: AssetImage("image/medications/drug_7.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),  // TODO: find picture
  const Medication(
    name: "Sodium valproate/ Depakin®",
    picture: AssetImage("image/medications/drug_8.png"),
    medicationIntakeMethod: LiquidMedication(200),
    sideEffects: "มือสั่น คลื่นไส้ อาเจียนปวดท้อง ผมร่วง น้ำหนักเพิ่ม",
    dangerSideEffects: "ตับอักเสบ ตับอ่อนอักเสบ",
  ),
  const Medication(
    name: "Topiramate / Topamax® (25 mg)",
    picture: AssetImage("image/medications/drug_9.png"),
    medicationIntakeMethod: PillMedication(25),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Topiramate / Topamax® (50 mg)",
    picture: AssetImage("image/medications/Topamax50.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Topiramate / Topamax® (100 mg)",
    picture: AssetImage("image/medications/Topamax100.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Vigabatrin / Sabril®",
    picture: AssetImage("image/medications/drug_10.png"),
    medicationIntakeMethod: PillMedication(500),
    sideEffects: "มึนงง ง่วงซึม",
    dangerSideEffects: "ความผิดปกติของลานสายตา",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (0.5 mg/ml)",
    picture: AssetImage("image/medications/drug_11.png"),
    medicationIntakeMethod: LiquidMedication(0.5),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),   // TODO: find picture
  const Medication(
    name: "Perampanel / Fycompa® (2 mg)",
    picture: AssetImage("image/medications/drug_11.png"),
    medicationIntakeMethod: PillMedication(2),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),   // TODO: find picture
  const Medication(
    name: "Perampanel / Fycompa® (4 mg)",
    picture: AssetImage("image/medications/drug_11.png"),
    medicationIntakeMethod: PillMedication(4),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (8 mg)",
    picture: AssetImage("image/medications/drug_11.png"),
    medicationIntakeMethod: PillMedication(8),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),  // TODO: find picture
  const Medication(
    name: "Lacosamide / Vimpat® (100 mg)",
    picture: AssetImage("image/medications/drug_12.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "มึนงง ง่วงซึม ภาพซ้อน เดินเซ",
    dangerSideEffects: "Atrioventricular block, palpitation",
  ),  // TODO: find picture
  const Medication(
    name: "Pregabalin / Lyrica® (25 mg)",
    picture: AssetImage("image/medications/drug_13.png"),
    medicationIntakeMethod: PillMedication(25),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const Medication(
    name: "Pregabalin / Lyrica® (75 mg)",
    picture: AssetImage("image/medications/Lyrica75.png"),
    medicationIntakeMethod: PillMedication(75),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const Medication(
    name: "Gabapentin / Neurontin® / Berlontin® (100 mg)",
    picture: AssetImage("image/medications/drug_14.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),  // TODO: find picture
  const Medication(
    name: "Gabapentin / Neurontin® / Berlontin® (300 mg)",
    picture: AssetImage("image/medications/drug_14.png"),
    medicationIntakeMethod: PillMedication(300),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
];
