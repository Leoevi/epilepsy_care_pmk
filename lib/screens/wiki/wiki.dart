// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/screens/commons/page_with_header_logo.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication_list.dart';
import 'package:epilepsy_care_pmk/screens/wiki/symptoms/symptom.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/icon_label_detail_button.dart';

class Wiki extends StatelessWidget {
  const Wiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLogo(
      child: ColumnWithSpacings(
        children: [
          IconLabelDetailButton(icon: const AssetImage("image/symptom_icon.png"), label: 'ข้อมูลโรคอาการลมชัก', detail: "เรื่องต่าง ๆ ที่ควรทราบเกี่ยวกับโรคลมชัก",onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Symptom()));
          },),
          IconLabelDetailButton(icon: const AssetImage("image/medication_icon.png"), label: 'ข้อมูลชนิดของยา', detail: "ศึกษาข้อมูลของยาที่ใช้เกี่ยวกับโรคลมชักได้ที่นี่", onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MedicationList(resultExpected: false,)));
          },),
        ],
      )
    );
  }
}
