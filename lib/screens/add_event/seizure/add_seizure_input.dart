import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/column_with_spacings.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class addSeizure extends StatefulWidget {
  const addSeizure({super.key});

  @override
  State<addSeizure> createState() => _addSeizureState();
}

class _addSeizureState extends State<addSeizure> {
  var seizure_symtomp; // Input อาการ
  var seizure_place; // Input สถานที่
  int id = 0; // เป็นตัว Counter ที่เอาไว้ใช้บอกว่ามาจาก Input ไหน
  TimeOfDay selectedTime = TimeOfDay.now(); // default time

  // method เก็บข้อมูลจาก Input
  void collect_data_from_text(val) {
    if (id == 1) {
      // อาการ
      setState(() {
        seizure_symtomp = val;
      });
    } else if (id == 2) {
      //สถานที่
      setState(() {
        seizure_place = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: "บันทึกอาการลมชัก",
        body: Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(kLargePadding),
                  child: SingleChildScrollView(
                    //we can make common
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Time
                        Text("โปรดกรอกเวลา", style: TextStyle(fontSize: 18)),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                //Collect data by use update_text function
                                enabled: false,
                                decoration: InputDecoration(
                                    hintText:
                                        "${selectedTime.hour} : ${selectedTime.minute} น.",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(width: 80),
                            ElevatedButton(
                              child: Text("เลือกเวลา",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              onPressed: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                  initialEntryMode: TimePickerEntryMode.dial,
                                );
                                if (timeOfDay != null) {
                                  setState(() {
                                    selectedTime = timeOfDay;
                                    //time result : timeOfDay
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                      255, 201, 128, 247), //Color(0x7FCA80F7)
                                  padding: EdgeInsets.all(20),
                                  fixedSize: Size.fromWidth(140),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            )
                          ],
                        ),

                        SizedBox(height: 30),

                        //field ระบุอาการ
                        Text("โปรดระบุอาการ", style: TextStyle(fontSize: 18)),

                        SizedBox(
                            height: 10), //spacing between label and TextInput

                        TextFormField(
                          //Collect data by use update_text function
                          onChanged: (val) {
                            id = 1;
                            collect_data_from_text(val);
                          },
                          decoration: InputDecoration(
                              hintText: "ระบุอาการ",
                              border: OutlineInputBorder()),
                        ),

                        SizedBox(height: 30), //spacing between input

                        //field ระบุสถานที่
                        Text("โปรดระบุสถานที่", style: TextStyle(fontSize: 18)),
                        SizedBox(
                            height: 10), //spacing between label and TextInput
                        TextFormField(
                          //Collect data by use update_text function
                          onChanged: (val) {
                            id = 2;
                            collect_data_from_text(val);
                          },
                          decoration: InputDecoration(
                              hintText: "ระบุสถานที่",
                              border: OutlineInputBorder()),
                        ),
                        // Text(
                        //     "input 1 : $seizure_symtomp ---- input 2 : $seizure_place")   Input value check

                        SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              child: Text("ยกเลิก",
                                  style: TextStyle(fontSize: 16)),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                      color:
                                          Color.fromARGB(255, 201, 128, 247)),
                                  padding: EdgeInsets.all(20),
                                  fixedSize: Size.fromWidth(140),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            ElevatedButton(
                              child: Text("ตกลง",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                      255, 201, 128, 247), //Color(0x7FCA80F7)
                                  padding: EdgeInsets.all(20),
                                  fixedSize: Size.fromWidth(140),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
