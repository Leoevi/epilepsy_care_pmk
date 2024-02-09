import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

class medAllergy extends StatefulWidget {
  const medAllergy({super.key});

  @override
  State<medAllergy> createState() => _medAllergyState();
}

class _medAllergyState extends State<medAllergy> {
  String? seizureSymptom; // Input อาการ
  Object? dropDownValue; // dropDown value
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "บันทึกอาการเเพ้ยา",
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(kLargePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  HorizontalDatePicker(),

                  Text("ชนิดของยาที่เกิดอาการเเพ้ยา",
                      style: TextStyle(fontSize: 18)),

                  SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: dropDownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (val) {
                      setState(() {
                        dropDownValue = val!;
                        // print(dropDownValue);
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                          child: Text("hello!"), value: "hello!"),
                      DropdownMenuItem<String>(
                          child: Text("hello2!"), value: "hello2!"),
                      DropdownMenuItem<String>(
                          child: Text("hello3!"), value: "hello3!"),
                    ],
                  ),

                  SizedBox(height: 20),
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
                              hintText: selectedTime.format(context),
                              // TODO: Change PM to 12-hour
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 80),
                      ElevatedButton(
                        child: Text("เลือกเวลา",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              selectedTime = timeOfDay;
                              //time result : timeOfDay
                              // print("time>>>>>> $selectedTime");
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

                  SizedBox(height: 20),

                  Text("โปรดระบุอาการ", style: TextStyle(fontSize: 18)),

                  SizedBox(height: 10),
                  //spacing between label and TextInput

                  TextFormField(
                    //Collect data by use update_text function
                    onChanged: (val) {
                      setState(() {
                        seizureSymptom = val;
                        // print(seizureSymptom);
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "ระบุอาการ", border: OutlineInputBorder()),
                  ),

                  SizedBox(height: 80),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text("ยกเลิก", style: TextStyle(fontSize: 16)),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Color.fromARGB(255, 201, 128, 247)),
                            padding: EdgeInsets.all(20),
                            fixedSize: Size.fromWidth(140),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                      ElevatedButton(
                        child: Text("ตกลง",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
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
          ),
        ),
      ),
    );
  }
}
