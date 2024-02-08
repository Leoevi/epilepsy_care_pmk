import 'package:flutter/material.dart';

import '../../commons/screen_with_app_bar.dart';

class SymptomDetail extends StatelessWidget {
  const SymptomDetail({
    super.key,
    required this.title,
    // required this.content,
  });

  final String title;
  // final List<TextSpan> content;

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: title,
      body: Text.rich(  // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
        TextSpan(
          locale: Locale("th"),
          children: [
            TextSpan(text: title + "\n"),  // TODO: make header style
            TextSpan(text: """
            โรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
            ในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
            ผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
            การวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
            1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
            2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
            3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
            อ้างอิงจาก http://www.pedceppmk.com"""), // TODO: trim the whitespaces from indentation
          ],
        ),
      )
    );
  }
}
