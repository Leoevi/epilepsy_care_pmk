import 'package:flutter/material.dart';

class Medication {
  const Medication({
    required this.name,
    required this.icon,
    required this.picture,
    required this.medicationIntakeMethod,
    required this.sideEffects,
    required this.dangerSideEffects,
    this.allergySymptoms,
  });

  /// The name of the medication, usually goes like "Actual name, Trademarked name"
  final String name;
  /// The picture that is the icon of the medication.
  /// Should be around 4x smaller that the picture.
  final ImageProvider<Object> icon;
  /// The actual detailed picture of the medication.
  final ImageProvider<Object> picture;
  /// The concentration of the medication, and also how it's taken.
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
    return "$mgPerPill mg/เม็ด";
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
    return "$mgPerMl mg/ml";
  }
}

final List<Medication> medicationEntries = [
  const Medication(
      name: "Carbamazepine / Tegretol®",
      icon: AssetImage("image/medications/icon/Tegretal_20mg_lqd.png"),
      picture: AssetImage("image/medications/picture/Tegretal_20mg_lqd.png"),
      medicationIntakeMethod: LiquidMedication(20),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
  const Medication(
    name: "Clonazepam / Rivotril® (0.5 mg)",
    icon: AssetImage("image/medications/icon/Rivotril_0,5mg_tbl.jpg"),
    picture: AssetImage("image/medications/picture/Rivotril_0,5mg_tbl.jpg"),
    medicationIntakeMethod: PillMedication(0.5),
    sideEffects: "อ่อนเพลีย ง่วง พฤติกรรมเปลี่ยนแปลง น้ำลายและเสมหะมาก",
    dangerSideEffects: "กดการหายใจ",
  ),
  const Medication(
      name: "Clonazepam / Rivotril® (2 mg)",
      icon: AssetImage("image/medications/icon/Rivotril_2mg_tbl.png"),
      picture: AssetImage("image/medications/picture/Rivotril_2mg_tbl.png"),
      medicationIntakeMethod: PillMedication(2),
      sideEffects: "อ่อนเพลีย ง่วง พฤติกรรมเปลี่ยนแปลง น้ำลายและเสมหะมาก",
      dangerSideEffects: "กดการหายใจ",
  ),
  const Medication(
      name: "Lamotrigine / Lamictal® (25 mg)",
      icon: AssetImage("image/medications/icon/Lamictal_25mg_tbl.png"),
      picture: AssetImage("image/medications/picture/Lamictal_25mg_tbl.png"),
      medicationIntakeMethod: PillMedication(25),
      sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
      dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Lamotrigine / Lamictal® (50 mg)",
    icon: AssetImage("image/medications/icon/Lamictal_50mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Lamictal_50mg_tbl.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Lamotrigine / Lamictal® (100 mg)",
    icon: AssetImage("image/medications/icon/Lamictal_100mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Lamictal_100mg_tbl.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Levetiracetam / Keppra®",
    icon: AssetImage("image/medications/icon/Keppra_100mg_lqd.png"),
    picture: AssetImage("image/medications/picture/Keppra_100mg_lqd.png"),
    medicationIntakeMethod: LiquidMedication(100),
    sideEffects: "ซึม มึนงง",
    dangerSideEffects: "อารมณ์หงุดหงิด ก้าวร้าว",
  ),
  const Medication(
    name: "Oxcarbazepine / Trileptal® (300 mg)",
    icon: AssetImage("image/medications/icon/Trileptal_300mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Trileptal_300mg_tbl.png"),
    medicationIntakeMethod: PillMedication(300),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "ภาวะโซเดียมต่ำ",
  ),
  // const Medication(
  //   name: "Oxcarbazepine / Trileptal® (600 mg)",
  //   picture: AssetImage("image/medications/Tripetal_600mg.png"),
  //   medicationIntakeMethod: PillMedication(600),
  //   sideEffects: "มึนงง ง่วงซึม เดินเซ",
  //   dangerSideEffects: "ภาวะโซเดียมต่ำ",
  // ),  // Doesn't use this drug anymore
  const Medication(
    name: "Phenobarbital (30 mg)",
    icon: AssetImage("image/medications/icon/Phenobarbital_30mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Phenobarbital_30mg_tbl.png"),
    medicationIntakeMethod: PillMedication(30),
    sideEffects: "เด็ก: ซุกซนไม่อยู่สุข พฤติกรรมเปลี่ยนแปลง ก้าวร้าว ผู้ใหญ่: ง่วงซึม อ่อนเพลีย",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Phenobarbital (60 mg)",
    icon: AssetImage("image/medications/icon/Phenobarbital_60mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Phenobarbital_60mg_tbl.png"),
    medicationIntakeMethod: PillMedication(60),
    sideEffects: "เด็ก: ซุกซนไม่อยู่สุข พฤติกรรมเปลี่ยนแปลง ก้าวร้าว ผู้ใหญ่: ง่วงซึม อ่อนเพลีย",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const Medication(
    name: "Phenytoin / Dilantin® (125 mg/5 ml)",
    icon: AssetImage("image/medications/icon/Dilantin_25mg_lqd.png"),
    picture: AssetImage("image/medications/picture/Dilantin_25mg_lqd.png"),
    medicationIntakeMethod: LiquidMedication(25),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),
  const Medication(
    name: "Phenytoin / Dilantin® (50 mg)",
    icon: AssetImage("image/medications/icon/Dilantin_50mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Dilantin_50mg_tbl.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),
  const Medication(
    name: "Phenytoin / Dilantin® (100 mg)",
    icon: AssetImage("image/medications/icon/Dilantin_100mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Dilantin_100mg_tbl.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),
  const Medication(
    name: "Sodium valproate/ Depakin®",
    icon: AssetImage("image/medications/icon/Depakine_200mg_lqd.png"),
    picture: AssetImage("image/medications/picture/Depakine_200mg_lqd.png"),
    medicationIntakeMethod: LiquidMedication(200),
    sideEffects: "มือสั่น คลื่นไส้ อาเจียนปวดท้อง ผมร่วง น้ำหนักเพิ่ม",
    dangerSideEffects: "ตับอักเสบ ตับอ่อนอักเสบ",
  ),
  const Medication(
    name: "Topiramate / Topamax® (25 mg)",
    icon: AssetImage("image/medications/icon/Topamax_25mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Topamax_25mg_tbl.png"),
    medicationIntakeMethod: PillMedication(25),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Topiramate / Topamax® (50 mg)",
    icon: AssetImage("image/medications/icon/Topamax_50mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Topamax_50mg_tbl.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Topiramate / Topamax® (100 mg)",
    icon: AssetImage("image/medications/icon/Topamax_100mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Topamax_100mg_tbl.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const Medication(
    name: "Vigabatrin / Sabril®",
    icon: AssetImage("image/medications/icon/Sabril_500mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Sabril_500mg_tbl.png"),
    medicationIntakeMethod: PillMedication(500),
    sideEffects: "มึนงง ง่วงซึม",
    dangerSideEffects: "ความผิดปกติของลานสายตา",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (0.5 mg/ml)",
    icon: AssetImage("image/medications/icon/Fycompa_0,5mg_lqd.png"),
    picture: AssetImage("image/medications/picture/Fycompa_0,5mg_lqd.png"),
    medicationIntakeMethod: LiquidMedication(0.5),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (2 mg)",
    icon: AssetImage("image/medications/icon/Fycompa_2mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Fycompa_2mg_tbl.png"),
    medicationIntakeMethod: PillMedication(2),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (4 mg)",
    icon: AssetImage("image/medications/icon/Fycompa_4mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Fycompa_4mg_tbl.png"),
    medicationIntakeMethod: PillMedication(4),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const Medication(
    name: "Perampanel / Fycompa® (8 mg)",
    icon: AssetImage("image/medications/icon/Fycompa_8mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Fycompa_8mg_tbl.png"),
    medicationIntakeMethod: PillMedication(8),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const Medication(
    name: "Lacosamide / Vimpat® (50 mg)",
    icon: AssetImage("image/medications/icon/Vimpat_50mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Vimpat_50mg_tbl.png"),
    medicationIntakeMethod: PillMedication(50),
    sideEffects: "มึนงง ง่วงซึม ภาพซ้อน เดินเซ",
    dangerSideEffects: "Atrioventricular block, palpitation",
  ),
  const Medication(
    name: "Pregabalin / Lyrica® (25 mg)",
    icon: AssetImage("image/medications/icon/Lyrica_25mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Lyrica_25mg_tbl.png"),
    medicationIntakeMethod: PillMedication(25),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const Medication(
    name: "Pregabalin / Lyrica® (75 mg)",
    icon: AssetImage("image/medications/icon/Lyrica_75mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Lyrica_75mg_tbl.png"),
    medicationIntakeMethod: PillMedication(75),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const Medication(
    name: "Gabapentin / Neurontin® / Berlontin® (100 mg)",
    icon: AssetImage("image/medications/icon/Berlontin_100mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Berlontin_100mg_tbl.png"),
    medicationIntakeMethod: PillMedication(100),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const Medication(
    name: "Gabapentin / Neurontin® / Berlontin® (300 mg)",
    icon: AssetImage("image/medications/icon/Berlontin_300mg_tbl.png"),
    picture: AssetImage("image/medications/picture/Berlontin_300mg_tbl.png"),
    medicationIntakeMethod: PillMedication(300),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
];
