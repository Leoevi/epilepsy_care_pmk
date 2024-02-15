import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
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
  'Gabapentin / Neurontin®  / Berlontin®' //Fix Overflow item by https://stackoverflow.com/a/55376107
];

class AddMedAllergyInput extends StatefulWidget {
  const AddMedAllergyInput({super.key});

  @override
  State<AddMedAllergyInput> createState() => _AddMedAllergyInputState();
}

class _AddMedAllergyInputState extends State<AddMedAllergyInput> {
  final _formKey = GlobalKey<FormState>(); //Validate
  String? seizureSymptom; // Input อาการ
  String dropDownValue = list.first; // dropDown init value
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  TimeOfDay selectedTime = TimeOfDay.now();

  void printAll() {
    debugPrint("seizureSymptom: $seizureSymptom");
    debugPrint("dropDownValue: $dropDownValue");
    debugPrint("selectedDate: $selectedDate");
    debugPrint("selectedTime: $selectedTime");
  }

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
              child: Form(
                key: _formKey, // validate
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    HorizontalDatePicker(
                      startDate: selectedDate,
                      onDateChange: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),

                    Text("ชนิดของยาที่เกิดอาการเเพ้ยา",
                        style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),

                    DropdownButtonFormField(
                      isExpanded: true, //https://stackoverflow.com/a/55376107
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (String? val) {
                        setState(() {
                          dropDownValue = val!;
                          // print(dropDownValue);
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
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
                          style: primaryButtonStyle,
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    Text("โปรดระบุอาการ", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),
                    //spacing between label and TextInput

                    TextFormField(
                      validator: (val) {
                        //validate
                        if (val == null || val.isEmpty) {
                          return 'กรุณาระบุอาการ';
                        }
                        return null;
                      },
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: secondaryButtonStyle,
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
                              printAll();  // TODO: remove later
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
          ),
        ),
      ),
    );
  }
}
