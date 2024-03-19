import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../helpers/trim_leading_whitespace.dart';

/// A class for each of the symptom entries
class SymptomEntry {
  SymptomEntry({
    required this.title,
    required this.content,
    required this.icon,
    required this.picture,
  });

  final String title;
  final Text content;
  final ImageProvider<Object>? icon;
  final Image picture;
  
}

final List<SymptomEntry> symptomEntries = [
  SymptomEntry(
      title: "โรคลมชักคืออะไร",
      content: Text.rich(
        // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
        TextSpan(
          locale: Locale("th"),
          children: [
            TextSpan(text: trimLeadingWhitespace("""
              ${indent}โรคลมชัก (epilepsy) คือ โรคที่ผู้ป่วยมีอาการชักซ้ำโดยที่ไม่มีปัจจัยกระตุ้น (provoking factor) ชัดเจน อาจจะพบพยาธิสภาพในสมองหรือไม่ก็ได้
              ${indent}ในกรณีผู้ป่วยชักครั้งแรกร่วมกับมีคลื่นไฟฟ้าสมองผิดปกติแบบ epileptiform discharge หรือมีรอยโรคใน สมอง จะมีโอกาสชักซ้ำสูง
              ${indent}ผู้ป่วยที่มีอาการชักจากความเจ็บป่วยปัจจุบัน เช่น ความผิดปกติทางเมตาโบลิก จากยา หรือ ไข้สูงในเด็ก โดยที่ไม่ได้มีพยาธิสภาพที่สมองชัดเจน จัดเป็นการชักที่มีปัจจัยชักนำ (provoked seizure) จึงไม่ถือว่าเป็นโรคลมชัก
              
              ${indent}การวินิจฉัยโรคลมชักใช้คำจำกัดความของโรคลมชักดังต่อไปนี้
              ${indent}1. อาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่ 2 ครั้งขึ้นไป โดยอาการชัก 2 ครั้งนั้นต้องมีระยะเวลาห่างกันตั้งแต่ 24 ชั่วโมง ขึ้นไป
              ${indent}2. อาการชักที่เกิดขึ้นเพียงครั้งเดียว โดยที่ไม่มีปัจจัยกระตุ้นในผู้ป่วยที่มีโอกาสเสี่ยงสูงที่จะมีอาการชักซ้ำโดยความเสี่ยงเท่ากับผู้ป่วยที่มีอาการชักโดยที่ไม่มีปัจจัยกระตุ้นตั้งแต่2ครั้งขึ้นไป
              ${indent}3. กลุ่มอาการโรคลมชัก (epileptic syndrome) ชนิดต่างๆเช่นภาวะชักชนิดเหม่อ (absence) เป็นต้น
              
              อ้างอิงจาก http://www.pedceppmk.com""")
            ),
          ],
        ),
      ),
      icon: AssetImage("image/seizure_wiki_info/seizure_wiki_1.jpeg"),
      picture: Image.asset("image/seizure_wiki_info/seizure_wiki_1.jpeg"),),
  SymptomEntry(
      title: "สาเหตุของอาการลมชัก",
      content: Text.rich(
        // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
        TextSpan(
          locale: Locale("th"),
          children: [
            TextSpan(text: trimLeadingWhitespace("""
              ${indent}สาเหตุของโรคลมชักเกิดจากภาวะใดๆก็ตามที่ก่อให้เกิดรอยโรคในสมอง เช่น อุบัติเหตุ, การติดเชื้อในสมอง,เนื้องอก และ ความผิดปกติของสมองแต่กำเนิดเป็นต้น
              ${indent}อย่างไรก็ดี การชักในเด็กส่วนใหญ่ โดยเฉพาะ เด็กที่มีพัฒนาการปกติมักตรวจไม่พบความผิดปกติของสมองใดๆ จากการตรวจทางรังสีวินิจฉัย
              
              การตรวจวินิจฉัย
              ${indent}การวินิจฉัยโรคลมชักเพื่อให้ทราบถึงสาเหตุที่แท้จริงมีความสำคัญ เพราะทำให้ได้การรักษาที่มีประสิทธิภาพ นอกจากแพทย์จะทำการซักประวัติอย่างละเอียดแล้ว ยังมีเครื่องมือที่ทันสมัย เพื่อช่วยยืนยันการวินิจฉัยเช่น 
              
              การตรวจคลื่นไฟฟ้าสมอง (EEG)
              ${indent}ช่วยวินิจฉัยโรคลมชัก และทำให้สามารถบอกตำแหน่งของสมองที่เกิดการชักและชนิดของการชักได้
              
              การตรวจเอกซเรย์คอมพิวเตอร์ (CT Scan) และการทำเอ็มอาร์ไอ (MRI)
              ${indent}ช่วยให้แพทย์เห็นภาพความผิดปกติของสมองที่เป็นสาเหตุของโรคลมชักได้""")
            ),
          ],
        ),
      ),
      icon: AssetImage("image/seizure_wiki_info/seizure_wiki_2.jpg"),
      picture: Image.asset("image/seizure_wiki_info/seizure_wiki_2.jpg"),),
  SymptomEntry(
      title: "ประเภทของการชัก",
      content: Text.rich(
        // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
        TextSpan(
          locale: Locale("th"),
          children: [
            TextSpan(text: trimLeadingWhitespace("""
              ${indent}ในปีพ.ศ. 2560 สมาพันธ์ต่อต้านโรคลมชักนานาชาติ(International League Against Epilepsy, ILAE) ได้มีการทบทวนและ เปลี่ยนแปลงคำจำกัดความและการจำแนกชนิด ของอาการชัก โดยจำแนกเป็น 3 ชนิด ได้แก่ 
              
              ${indent}1. อาการชักที่มีจุดกำเนิดเฉพาะที่ (focal onset) 
              ${indent}คือ อาการชักที่เกิดจากการเปลี่ยนแปลงของคลื่นไฟฟ้าสมองของสมองเฉพาะบางจุด โดยจำแนกอาการชักแบบเฉพาะที่เป็น 3 ชนิดย่อยดังนี้ 
              ${indent}• อาการชักเฉพาะที่โดยผู้ป่วยรู้สึกตัวดี (focal aware seizure) 
              ${indent}• อาการชักเฉพาะที่โดยผู้ป่วยไม่รู้สึกตัว (focal impaired awareness) 
              ${indent}• อาการชักเฉพาะที่ตามด้วยชักเกร็งกระตุกทั้งตัว(focal to bilateral tonic-clonic seizure) 
              
              ${indent}2. อาการชักจากสมองทุกส่วน (Generalized onset) 
              ${indent}คืออาการชักที่เกิดจากการเปลี่ยนแปลงของคลื่นไฟฟ้าสมองทั้ง 2 ซีกตั้งแต่เริ่มต้นของการชัก มีชนิดของอาการชักที่พบได้บ่อยได้แก่อาการชักแบบเหม่อ (Absence seizure) อาการชักสะดุ้ง (myoclonic seizure) และอาการชักชนิดตัวอ่อน (Atonic seizure ) อาการชักกระตุกทั้งตัว (generalized tonic-clonic seizure) เป็นต้น 
              
              ${indent}3. อาการชักที่ไม่ทราบจุดกำเนิดชัดเจน (Unknown onset) 
              ${indent}คืออาการชักที่ไม่ทราบจุดกำเนิดของคลื่นชัก ไม่สามารถเข้าได้กับ สองชนิดแรกอาจแยกย่อยเป็น อาการชักแบบเกร็งกระตุก (tonic-clonic), อาการชักแบบผวา (epileptic spasms) หรือแบบหยุดพฤติกรรมที่ทำอยู่ (behavior arrest)เป็นต้น
              """)
            ),
          ],
        ),
      ),
      icon: AssetImage("image/seizure_wiki_info/seizure_wiki_3.jpeg"),
      picture: Image.asset("image/seizure_wiki_info/seizure_wiki_3.jpeg"),),
  SymptomEntry(
      title: "การรักษาโรคลมชัก",
      content: Text.rich(
        // https://stackoverflow.com/questions/41557139/how-do-i-bold-or-format-a-piece-of-text-within-a-paragraph
        TextSpan(
          locale: Locale("th"),
          children: [
            TextSpan(text: trimLeadingWhitespace("""
              ${indent}1. การใช้ยากันชัก เป็นการรักษาหลักของโรคลมชัก โดยทั่วไปต้องรับประทานยากันชักติดต่อกันอย่างน้อย 2 ปีหรือนานกว่านั้น ในปัจจุบันยากันชักมีอยู่หลายชนิด ซึ่งแพทย์จะพิจารณาเลือกให้เหมาะสมกับอาการชัก รวมถึงพิจารณาความปลอดภัยและประสิทธิภาพในการควบคุมอาการชัก
              ${indent}2. อาหารคีโตน
              ${indent}3. การผ่าตัดโรคลมชัก มีข้อบ่งชี้ในผู้ป่วยโรคลมชักที่มีภาวะดื้อต่อยากันชัก ส่งผลกระทบต่อคุณภาพชีวิต หรือผู้ป่วยมีรอยโรคในสมองที่รักษาด้วยการผ่าตัดได้
              อ้างอิงจาก http://www.pedceppmk.com 
              
              ${indent}วิธีการปฐมพยาบาล ผู้ป่วยขณะชัก
              ${indent}1. ถอดแว่นตา คลายกระดุม ที่คอเสื้อ คลายเข็มขัดที่กางเกงหรือกระโปรง 
              ${indent}2. จับนอนตะแคงบนพื้นหรือบนเตียงห่างจากสิ่งอันตรายต่างๆ และหันศีรษะไปด้านใดด้านหนึ่งเพื่อป้องกันการสำลักและลิ้นตกไปอุดกั้นทางเดินหายใจ ดังรูป 
              ${indent}3. ห้ามงัดปากหรือสอดใส่วัตถุใดๆ ในช่องปากขณะชัก เพราะอาจจะทำให้ฟันหัก หรือสำลัก และเกิดอันตรายได้
              ${indent}4. ห้ามกรอกยาขณะชัก เพราะอาจทำให้สำลักได้ 
              ${indent}5. ห้ามจับมัดหรือตรึง เพราะอาจทำให้ชักมากขึ้นหรือนานขึ้น และอาจทำให้เกิดการฟกช้ำหรือกระดูกหักได้ 
              ${indent}6. เฝ้าสังเกตอาการผู้ป่วยขณะชัก และจับเวลาที่เกิดอาการชัก หรืออาจใช้การบันทึกภาพวิดีโอ ตามปกติผู้ป่วยลมชักจะมีอาการสงบลงได้เองเมื่อผ่านไป 2-3 นาที หากมีอาการชักเกิน 5 นาทีควรรีบส่งแพทย์ 
              ${indent}7. ถ้าอาการดีขึ้นและมียากันชักกินอยู่แล้ว ควรรีบปรึกษาหมอเรื่องการปรับยาใหม่ ไม่ควรเพิ่มยาเอง 
              
              ที่มา : https://epilepsy.kku.ac.th/poster.htm  
              """)
            ),
          ],
        ),
      ),
      icon: AssetImage("image/seizure_wiki_info/seizure_wiki_6.jpg"),
      picture: Image.asset("image/seizure_wiki_info/seizure_wiki_6.jpg"),),
];
