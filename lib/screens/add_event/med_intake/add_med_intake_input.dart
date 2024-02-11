import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/custom_widgets/icon_label_detail_button.dart';
import 'package:epilepsy_care_pmk/custom_widgets/time_input.dart';
import 'package:epilepsy_care_pmk/screens/add_event/add_select.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class addMedTake extends StatefulWidget {
  const addMedTake({super.key});

  @override
  State<addMedTake> createState() => _addMedTakeState();
}

class _addMedTakeState extends State<addMedTake> {
  final _formKey = GlobalKey<FormState>(); //Validate
  String? seizureDose; // Input ปริมาณ
  String dropDownValue = list.first; // dropDown init value
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  TimeOfDay selectedTime = TimeOfDay.now(); // default time
  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: "บันทึกปริมาณยา",
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(kLargePadding),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    HorizontalDatePicker(),

                    Text("ชนิดของยาที่บันทึก", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (String? val) {
                        setState(() {
                          dropDownValue = val!;
                          // print(dropDownValue);
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

                    Text("โปรดระบุปริมาณยา", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),
                    //spacing between label and TextInput

                    TextFormField(
                      validator: (val) {
                        //validate
                        if (val == null || val.isEmpty) {
                          return 'กรุณาระบุปริมาณยา';
                        }
                        return null;
                      },
                      //Collect data by use update_text function
                      onChanged: (val) {
                        setState(() {
                          seizureDose = val;
                          // print(seizureSymptom);
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "ระบุปริมาณยา",
                          border: OutlineInputBorder()),
                    ),

                    SizedBox(height: 80),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          child: Text("ยกเลิก", style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                          label: 'ปิด',
                                          textColor: Colors.black,
                                          onPressed: () {}),
                                      content: Text('บันทึกข้อมูลสำเร็จ')));

                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
