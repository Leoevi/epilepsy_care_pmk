import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

const List<String> alarmModeList = <String>[
  //DropDown Item List (All Alarm Mode)
  'ทุกวัน',
  'ทุก 2 วัน',
  'ทุก 3 วัน',
];

const List<String> drugList = <String>[
  //DropDown Item List (All Drug)
  'Carbamazepine / Tegretol®',
  'Clonazepam / Rivotrill®',
  'Lamotrigine / Lamictal®',
  'Levetiracetam / Keppra®',
  'Oxcarbazepine / Trileptal®',
  'Phenobarbital',
  'Phenytoin / Dilantin®',
  'Sodium valproate / Depakin®',
  'Topiramate / Topamax®',
  'Vigabatrin / Sabril®',
  'Perampanel / Fycompa®',
  'Lacosamide / Vimpat®',
  'Pregabalin / Lyrica®',
  'Gabapentin / Neurontin® / Berlontin®'
];

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  @override
  final _formKey = GlobalKey<FormState>(); //Validate

  String? medDose; // Input อาการ
  String? medTakeDetail; // Input สถานที่
  String drugDropDownValue = drugList.first; // dropDown init value
  String alarmModeDropDownValue = alarmModeList.first;
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  TimeOfDay selectedTime = TimeOfDay.now(); // default time

  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: "ตั้งเวลากินยา",
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

                          Text("ชื่อยาที่บันทึก",
                              style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            isExpanded: true,
                            value: drugDropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            onChanged: (String? val) {
                              setState(() {
                                drugDropDownValue = val!;
                              });
                            },
                            items: drugList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 20),

                          //field ปริมาณยา
                          Text("โปรดระบุปริมาณยา",
                              style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),
                          //spacing between label and TextInput

                          TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'กรุณาระบุปริมาณยา';
                              }
                              return null;
                            },
                            //Collect data by use update_text function
                            onChanged: (val) {
                              setState(() {
                                medDose = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "ระบุปริมาณยา",
                                border: OutlineInputBorder()),
                          ),

                          SizedBox(height: 20),

                          //field รายละเอียด
                          Text("โปรดระบุรายละเอียด",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          //spacing between label and TextInput
                          TextFormField(
                            //validate สถานที่
                            // validator: (val) {
                            //   if (val == null || val.isEmpty) {
                            //     return 'กรุณาระบุรายละเอียด';
                            //   }
                            //   return null;
                            // },
                            //Collect data by use update_text function
                            onChanged: (val) {
                              setState(() {
                                medTakeDetail = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "ระบุรายละเอียด",
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 20),
                          // Text(
                          //     "input 1 : $seizure_symtomp ---- input 2 : $seizure_place")   Input value check
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
                          //spacing between input
                          Text("ชื่อยาที่บันทึก",
                              style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            value: alarmModeDropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            onChanged: (String? val) {
                              setState(() {
                                alarmModeDropDownValue = val!;
                              });
                            },
                            items: alarmModeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

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
                                            content: Text(
                                                'บันทึกการเเจ้งเตือนสำเร็จ')));
                                    //printAll();  // TODO: remove this if not needed
                                    Navigator.pop(
                                        context); //back to AlarmMedIntake when add success
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
