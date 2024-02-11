import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/helpers/trim_leading_whitespace.dart';
import 'package:flutter/material.dart';

import '../../commons/screen_with_app_bar.dart';

class SymptomDetail extends StatelessWidget {
  const SymptomDetail({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;

  final Text content;

  @override
  Widget build(BuildContext context) {
    // Straight from https://api.flutter.dev/flutter/material/SliverAppBar-class.html
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            stretch: true,
            onStretchTrigger: () async {
              // Triggers when stretching
            },
            // [stretchTriggerOffset] describes the amount of overscroll that must occur
            // to trigger [onStretchTrigger]
            //
            // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
            // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
            stretchTriggerOffset: 300.0,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('SliverAppBar',
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall!.color,
                ),),
              background: FlutterLogo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(kLargePadding),
              child: Text.rich(
                // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
                TextSpan(
                  locale: Locale("th"),
                  children: [
                    TextSpan(text: "pls change" + "\n"), // TODO: make header style
                    TextSpan(text: trimLeadingWhitespace("""
                      
                  $indentโรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
                  $indentในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
                  $indentผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
                  $indentการวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
                  ${indent}1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
                  ${indent}2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
                  ${indent}3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
                  
                  $indentโรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
                  $indentในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
                  $indentผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
                  $indentการวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
                  ${indent}1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
                  ${indent}2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
                  ${indent}3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
                  
                  $indentโรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
                  $indentในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
                  $indentผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
                  $indentการวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
                  ${indent}1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
                  ${indent}2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
                  ${indent}3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
                
                  $indentโรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
                  $indentในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
                  $indentผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
                  $indentการวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
                  ${indent}1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
                  ${indent}2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
                  ${indent}3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
                  
                  อ้างอิงจาก http://www.pedceppmk.com""")
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
