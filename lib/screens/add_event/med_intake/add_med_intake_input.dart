import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication_entry.dart';
import 'package:flutter/material.dart';

// const List<String> list = <String>[ //DropDown Item List (All Drug)
//   'Carbamazepine / Tegretol®',
//   'Clonazepam / Rivotrill®',
//   'Lamotrigine / Lamictal®',
//   'Levetiracetam / Keppra®',
//   'Oxcarbazepine / Trileptal®',
//   'Phenobarbital',
//   'Phenytoin / Dilantin®',
//   'Sodium valproate / Depakin®',
//   'Topiramate / Topamax®',
//   'Vigabatrin / Sabril®',
//   'Perampanel / Fycompa®',
//   'Lacosamide / Vimpat®',
//   'Pregabalin / Lyrica®',
//   'Gabapentin / Neurontin® / Berlontin®'
// ];

class AddMedIntakeInput extends StatefulWidget {
  const AddMedIntakeInput({super.key});

  @override
  State<AddMedIntakeInput> createState() => _AddMedIntakeInputState();
}

class _AddMedIntakeInputState extends State<AddMedIntakeInput> {
  DateTime selectedDate = DateTime.now(); // Date from datepicker
  MedicationEntry? selectedMedication; // dropDown init value
  TimeOfDay selectedTime = TimeOfDay.now(); // default time
  String? medicationQuantity; // Input ปริมาณ
  MeasureUnit? selectedMeasureUnit;

  late final List<DropdownMenuItem<MedicationEntry>> medDropdownList;  // DropdownMenuItem is a generic, so we will assign it type that we need straight away.
  List<DropdownMenuItem<MeasureUnit>>? unitDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate

  void printAll() {
    debugPrint("seizureDose: $medicationQuantity");
    debugPrint("dropDownValue: $selectedMedication");
    debugPrint("selectedDate: $selectedDate");
    debugPrint("selectedTime: $selectedTime");
  }

  @override
  void initState() {
    super.initState();
    medDropdownList = medicationEntries.map<DropdownMenuItem<MedicationEntry>>((entry) {
      return DropdownMenuItem<MedicationEntry>(
        value: entry,
        child: Text(entry.name),
      );
    }).toList();
  }

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
                    HorizontalDatePicker(
                      startDate: selectedDate,
                      onDateChange: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),

                    Text("ชนิดของยาที่บันทึก", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),

                    DropdownButtonFormField(
                      isExpanded: true,
                      value: selectedMedication,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (MedicationEntry? val) {
                        // 2 things that this onChange does
                        // 1) set the selectedMedication
                        setState(() {
                          selectedMedication = val!;
                          selectedMeasureUnit = null;  // For some reason, not setting this to null will cause an assertion error saying that there are 0 or 2 duplicate entries in the unit's drop down menu.
                          // print(dropDownValue);
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
                          style: primaryButtonStyle
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    Text("โปรดระบุปริมาณยา", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),
                    //spacing between label and TextInput

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'กรุณาระบุปริมาณยา';
                              }
                              return null;
                            },
                            //Collect data by use update_text function
                            onChanged: (val) {
                              setState(() {
                                medicationQuantity = val;
                                // print(seizureSymptom);
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
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          onChanged: (MeasureUnit? val) {
                            setState(() {
                              selectedMeasureUnit = val!;
                              // print(dropDownValue);
                            });
                          },
                          items: unitDropdownList,
                        ),)
                      ],
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
                          style: primaryButtonStyle
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
