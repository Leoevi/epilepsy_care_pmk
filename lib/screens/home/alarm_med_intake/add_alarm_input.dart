import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> alarmModeList = <String>[
  //DropDown Item List (All Alarm Mode)
  'ทุกวัน',
  'ทุก 2 วัน',
  'ทุก 3 วัน',
];

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  Medication? selectedMedication; // dropDown init value
  String? medicationQuantity; // Input ปริมาณยา
  MeasureUnit? selectedMeasureUnit;
  String? alarmDetail; // Input รายละเอียด
  String selectedRepetition = alarmModeList.first;
  TimeOfDay selectedTime = TimeOfDay.now(); // default time

  late final List<DropdownMenuItem<Medication>> medDropdownList;  // DropdownMenuItem is a generic, so we will assign it type that we need straight away.
  List<DropdownMenuItem<MeasureUnit>>? unitDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate

  @override
  void initState() {
    super.initState();
    medDropdownList = medicationEntries.map<DropdownMenuItem<Medication>>((entry) {
      return DropdownMenuItem<Medication>(
        value: entry,
        child: Text(entry.name),
      );
    }).toList();
  }

  @override
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
                            value: selectedMedication,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            onChanged: (Medication? val) {
                              // 2 things that this onChange does
                              // 1) set the selectedMedication
                              setState(() {
                                selectedMedication = val!;
                                selectedMeasureUnit = null;  // For some reason, not setting this to null will cause an assertion error saying that there are 0 or 2 duplicate entries in the unit's drop down menu.
                              });

                              // 2) Update the measure drop down menu
                              // use the ".?" operator to make the whole expr null if selectedMedication is null
                              unitDropdownList = selectedMedication?.medicationIntakeMethod.measureList.map<DropdownMenuItem<MeasureUnit>>((measure) {
                                return DropdownMenuItem<MeasureUnit>(
                                  value: measure,
                                  child: Text(measure.measureName),
                                );
                              }).toList();
                            },
                            items: medDropdownList,
                            validator: (val) {
                              if (val == null) {
                                return "กรุณาเลือกยาที่จะบันทึก";
                              }
                            },
                          ),

                          SizedBox(height: 20),

                          //field ปริมาณยา
                          Text("โปรดระบุปริมาณยา", style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),
                          //spacing between label and TextInput

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,  // This is so that error msg from validator doesn't misalign the whole widget
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  // https://stackoverflow.com/questions/49577781/how-to-create-number-input-field-in-flutter & https://stackoverflow.com/a/61215563
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'กรุณาระบุปริมาณยา';
                                    }
                                    else if (double.tryParse(val) == null) {
                                      return 'กรุณาระบุตัวเลขที่ถูกต้อง';
                                    }
                                    return null;
                                  },
                                  //Collect data by use update_text function
                                  onChanged: (val) {
                                    setState(() {
                                      medicationQuantity = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "ระบุปริมาณยา",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(width: kSmallPadding,),
                              Expanded(child: DropdownButtonFormField(
                                isExpanded: true,
                                value: selectedMeasureUnit,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "หน่วย",  // For some reason, on first render, the word "หน่วย" isn't vertically center, instead it drops below a bit, I tried to fix it with hintStyle according to https://github.com/flutter/flutter/issues/40248, but it wasn't enough
                                  hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
                                  errorMaxLines: 3,
                                ),
                                onChanged: (MeasureUnit? val) {
                                  setState(() {
                                    selectedMeasureUnit = val!;
                                  });
                                },
                                items: unitDropdownList,
                                validator: (val) {
                                  if (val == null) {
                                    return "กรุณาเลือกหน่วยของปริมาณยา";
                                  }
                                },
                              ),)
                            ],
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
                                alarmDetail = val;
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
                          Text("แจ้งเตือนซ้ำ",
                              style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            value: selectedRepetition,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            onChanged: (String? val) {
                              setState(() {
                                selectedRepetition = val!;
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
                                style: secondaryButtonStyle
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
