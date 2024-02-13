import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/horizontal_date_picker.dart';

const List<String> list = <String>['ชักทั้งตัว', 'ชักเฉพาะ', 'เหม่อลอย', 'อื่นๆ'];

class AddSeizureInput extends StatefulWidget {
  const AddSeizureInput({super.key});

  @override
  State<AddSeizureInput> createState() => _AddSeizureInputState();
}

class _AddSeizureInputState extends State<AddSeizureInput> {
  final _formKey = GlobalKey<FormState>(); //Validate

  String? seizureSymptom; // Input อาการ
  String? seizurePlace; // Input สถานที่
  String dropDownValue = list.first; // dropDown init value
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  TimeOfDay selectedTime = TimeOfDay.now(); // default time

  void printAll() {
    debugPrint("seizureSymptom: $seizureSymptom");
    debugPrint("seizurePlace: $seizurePlace");
    debugPrint("dropDownValue: $dropDownValue");
    debugPrint("selectedDate: $selectedDate");
    debugPrint("selectedTime: $selectedTime");
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Start here

                          HorizontalDatePicker(
                            startDate: selectedDate,
                            onDateChange: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          ),

                          Text("เพิ่มอาการชัก", style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            value: dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            onChanged: (String? val) {
                              setState(() {
                                dropDownValue = val!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
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
                                    });
                                  }
                                },
                                style: primaryButtonStyle,
                              )
                            ],
                          ),

                          SizedBox(height: 20),

                          //field ระบุอาการ
                          Text("โปรดระบุอาการ", style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),
                          //spacing between label and TextInput

                          TextFormField(
                            //Collect data by use update_text function
                            onChanged: (val) {
                              setState(() {
                                seizureSymptom = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "ระบุอาการ",
                                border: OutlineInputBorder()),
                          ),

                          SizedBox(height: 20),
                          //spacing between input

                          //field ระบุสถานที่
                          Text("โปรดระบุสถานที่",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          //spacing between label and TextInput
                          TextFormField(
                            //validate สถานที่
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'กรุณาระบุสถานที่';
                              }
                              return null;
                            },
                            //Collect data by use update_text function
                            onChanged: (val) {
                              setState(() {
                                seizurePlace = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "ระบุสถานที่",
                                border: OutlineInputBorder()),
                          ),
                          // Text(
                          //     "input 1 : $seizure_symtomp ---- input 2 : $seizure_place")   Input value check

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: Text("ยกเลิก",
                                    style: TextStyle(fontSize: 16)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 201, 128, 247)),
                                    padding: EdgeInsets.all(20),
                                    fixedSize: Size.fromWidth(140),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                              ElevatedButton(
                                child: Text("ตกลง",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                onPressed: () {
                                  //validate check
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            action: SnackBarAction(
                                                label: 'ปิด',
                                                textColor: Colors.black,
                                                onPressed: () {}),
                                            content:
                                                Text('บันทึกข้อมูลสำเร็จ')));
                                    printAll();  // TODO: remove this if not needed
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  }
                                },
                                style: primaryButtonStyle,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
