import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/models/alarm.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../custom_widgets/medication_selection_form.dart';
import '../../../custom_widgets/time_of_day_dropdown.dart';


class AddAlarmInput extends StatefulWidget {
  final Alarm? initAlarm;

  const AddAlarmInput({
    super.key,
    this.initAlarm,
    required this.isGranted,
  });

  /// A variable that will determined whether or not the notification permission
  /// has been granted, will be used to determined the "enable" status of the
  /// new created notification.
  final bool isGranted;

  @override
  State<AddAlarmInput> createState() => _AddAlarmInputState();
}

class _AddAlarmInputState extends State<AddAlarmInput> {
  late final List<DropdownMenuItem<Medication>> _medDropdownList;  // DropdownMenuItem is a generic, so we will assign it type that we need straight away.
  List<DropdownMenuItem<MeasureUnit>>? _unitDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate
  TextEditingController medicationQuantityController = TextEditingController();

  Medication? _inputMedication; // dropDown init value
  String? _inputMedicationQuantity; // Input ปริมาณยา
  MeasureUnit? _inputMeasureUnit;
  TimeOfDay? _inputTime; // default time

  @override
  void initState() {
    super.initState();

    if (widget.initAlarm != null) {
      _inputMedication = medicationEntries.firstWhere((med) => med.name == widget.initAlarm?.med);
      _generateUnitDropdownList();

      _inputMedicationQuantity = widget.initAlarm!.quantity.toString();
      medicationQuantityController.text = _inputMedicationQuantity!;
      _inputMeasureUnit = _inputMedication!.medicationIntakeMethod.measureList.firstWhere((unit) => unit.measureName == widget.initAlarm!.unit);

      _inputTime = widget.initAlarm!.time;
    }
  }

  /// TextEditingController requires disposing after use.
  @override
  void dispose() {
    medicationQuantityController.dispose();
    super.dispose();
  }

  void addToDb() {
    double quantity = double.parse(_inputMedicationQuantity!);
    Alarm alarm = Alarm(
        time: _inputTime!,
        med: _inputMedication!.name,
        quantity: quantity,
        unit: _inputMeasureUnit!.measureName,
        enable: widget.isGranted
    );
    DatabaseService.addAlarm(alarm);
  }

  void updateToDb() {
    double quantity = double.parse(_inputMedicationQuantity!);
    Alarm alarm = Alarm(
        alarmId: widget.initAlarm!.alarmId,
        time: _inputTime!,
        med: _inputMedication!.name,
        quantity: quantity,
        unit: _inputMeasureUnit!.measureName,
        // depend on isGranted
        enable: widget.isGranted && widget.initAlarm!.enable
    );
    DatabaseService.updateAlarm(alarm);
  }

  void _generateUnitDropdownList() {
    _unitDropdownList = _inputMedication?.medicationIntakeMethod.measureList.map<DropdownMenuItem<MeasureUnit>>((measure) {
      return DropdownMenuItem<MeasureUnit>(
        value: measure,
        child: Text(measure.measureName),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: (widget.initAlarm == null) ? "การแจ้งเตือนใหม่" : "แก้ไขการแจ้งเตือน",
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

                          const Text("ชื่อยาที่บันทึก",
                              style: TextStyle(fontSize: 18)),

                          const SizedBox(height: 10),

                          MedicationSelectionForm(
                              validator: (selectedMed) {
                                if (selectedMed == null) {
                                  return "กรุณาเลือกยาที่จะบันทึก";
                                }
                                return null;
                              },
                              medication: _inputMedication,
                              onChanged: (newMed) {
                                setState(() {
                                  // 1) set the selectedMedication
                                  _inputMedication = newMed;
                                  // 2) Update and clear the measure drop down menu
                                  _inputMeasureUnit = null;
                                  _generateUnitDropdownList();
                                  // 3) Clear medication quantity text field
                                  _inputMedicationQuantity = null;
                                  medicationQuantityController.clear();
                                });
                              }),

                          const SizedBox(height: 20),

                          //field ปริมาณยา
                          const Text("โปรดระบุปริมาณยา", style: TextStyle(fontSize: 18)),

                          const SizedBox(height: 10),
                          //spacing between label and TextInput

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,  // This is so that error msg from validator doesn't misalign the whole widget
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: medicationQuantityController,
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
                                      _inputMedicationQuantity = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "ระบุปริมาณยา",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: kSmallPadding,),
                              Expanded(child: DropdownButtonFormField(
                                isExpanded: true,
                                value: _inputMeasureUnit,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "หน่วย",  // For some reason, on first render, the word "หน่วย" isn't vertically center, instead it drops below a bit, I tried to fix it with hintStyle according to https://github.com/flutter/flutter/issues/40248, but it wasn't enough
                                  hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
                                  errorMaxLines: 3,
                                ),
                                onChanged: (MeasureUnit? val) {
                                  setState(() {
                                    _inputMeasureUnit = val!;
                                  });
                                },
                                items: _unitDropdownList,
                                validator: (val) {
                                  if (val == null) {
                                    return "กรุณาเลือกหน่วยของปริมาณยา";
                                  }
                                  return null;
                                },
                              ),)
                            ],
                          ),

                          const SizedBox(height: 20),

                          //Time
                          const Text("โปรดกรอกเวลา", style: TextStyle(fontSize: 18)),

                          const SizedBox(height: 10),

                          TimeOfDayDropdown(
                            startingTime: _inputTime,
                            onTimeChanged: (newTime) {
                              _inputTime = newTime;
                            },
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: secondaryButtonStyle,
                                child: const Text("ยกเลิก",
                                    style: TextStyle(fontSize: 16))
                              ),
                              ElevatedButton(
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
                                            content: const Text(
                                                'บันทึกการเเจ้งเตือนสำเร็จ')));
                                    if (widget.initAlarm == null) {
                                      addToDb();
                                    } else {
                                      updateToDb();
                                    }
                                    Navigator.pop(
                                        context); //back to AlarmMedIntake when add success
                                  }
                                },
                                style: primaryButtonStyle,
                                child: const Text("ตกลง",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
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
