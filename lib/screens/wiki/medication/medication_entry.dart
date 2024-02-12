import 'package:flutter/material.dart';

class MedicationEntry {
  const MedicationEntry({
    required this.name,
    required this.picture,
    this.dosage,
    required this.sideEffects,
    required this.dangerSideEffects,
    this.allergySymptoms,
  });

  final String name;
  final ImageProvider<Object> picture;
  final String? dosage;
  final String sideEffects;
  final String dangerSideEffects;
  final String? allergySymptoms;
}

final List<MedicationEntry> medicationEntries = [
  const MedicationEntry(
      name: "Carbamazepin / Tegretal®",
      picture: AssetImage("image/medications/drug_1.jpg"),
      sideEffects: "คลื่นไส้ ซึม เดินเซ เห็นภาพซ้อน",
      dangerSideEffects: "Hyponatremia (SIADH), Aplastic anemia, ตับอักเสบ เม็ดเลือดขาวต่ำ",
      allergySymptoms: "skin rash, Steven Johnson syndrome*"
  ),
  const MedicationEntry(
      name: "Clonazepam / Rivotril®",
      picture: AssetImage("image/medications/drug_2.png"),
      sideEffects: "อ่อนเพลีย ง่วง พฤติกรรมเปลี่ยนแปลง น้ำลายและเสมหะมาก",
      dangerSideEffects: "กดการหายใจ",
  ),
  const MedicationEntry(
      name: "Lamotrigine / Lamictal®",
      picture: AssetImage("image/medications/drug_3.png"),
      sideEffects: "มึนงง เห็นภาพซ้อน เดินเซ",
      dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const MedicationEntry(
    name: "Levetiracetam /  Keppra®",
    picture: AssetImage("image/medications/drug_4.png"),
    sideEffects: "ซึม มึนงง",
    dangerSideEffects: "อารมณ์หงุดหงิด ก้าวร้าว",
  ),
  const MedicationEntry(
    name: "Oxcarbazepine / Trileptal®",
    picture: AssetImage("image/medications/drug_5.png"),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "ภาวะโซเดียมต่ำ",
  ),
  const MedicationEntry(
    name: "Phenobarbital",
    picture: AssetImage("image/medications/drug_6.png"),
    sideEffects: "เด็ก: ซุกซนไม่อยู่สุข พฤติกรรมเปลี่ยนแปลง ก้าวร้าว ผู้ใหญ่: ง่วงซึม อ่อนเพลีย",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome",
  ),
  const MedicationEntry(
    name: "Phenytoin / Dilantin®",
    picture: AssetImage("image/medications/drug_7.png"),
    sideEffects: "เวียนศีรษะ เห็นภาพซ้อน ซึม เดินเซ คลื่นไส้ อาเจียน เหงือกบวม หน้าหยาบ ขนเยอะ สิวเพิ่มขึ้น",
    dangerSideEffects: "ผื่น Stevens-Johnson syndrome ตับอักเสบ",
  ),
  const MedicationEntry(
    name: "Sodium valproate/ Depakin®",
    dosage: "25 mg",
    picture: AssetImage("image/medications/drug_8.png"),
    sideEffects: "มือสั่น คลื่นไส้ อาเจียนปวดท้อง ผมร่วง น้ำหนักเพิ่ม",
    dangerSideEffects: "ตับอักเสบ ตับอ่อนอักเสบ",
  ),
  const MedicationEntry(
    name: "Topiramate / Topamax®",
    picture: AssetImage("image/medications/drug_9.png"),
    sideEffects: "มึนงง เดินเซ ความคิดเชื่องช้า การพูดผิดปกติ น้ำหนักลด",
    dangerSideEffects: "นิ่วในไต ต้อหิน เหงื่อออกน้อย",
  ),
  const MedicationEntry(
    name: "Vigabatrin / Sabril®",
    picture: AssetImage("image/medications/drug_10.png"),
    sideEffects: "มึนงง ง่วงซึม",
    dangerSideEffects: "ความผิดปกติของลานสายตา",
  ),
  const MedicationEntry(
    name: "Perampanel / Fycompa®",
    picture: AssetImage("image/medications/drug_11.png"),
    sideEffects: "มึนงง ง่วงซึม เดินเซ",
    dangerSideEffects: "หงุดหงิด ก้าวร้าว อาการทางจิต",
  ),
  const MedicationEntry(
    name: "Lacosamide / Vimpat®",
    picture: AssetImage("image/medications/drug_12.png"),
    sideEffects: "มึนงง ง่วงซึม ภาพซ้อน เดินเซ",
    dangerSideEffects: "Atrioventricular block, palpitation",
  ),
  const MedicationEntry(
    name: "Pregabalin / Lyrica®",
    picture: AssetImage("image/medications/drug_13.png"),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
  const MedicationEntry(
    name: "Gabapentin / Neurontin® / Berlontin®",
    picture: AssetImage("image/medications/drug_14.png"),
    sideEffects: "ง่วงนอน ซึม เวียนศีรษะ",
    dangerSideEffects: "มักไม่ค่อยพบ",
  ),
];
