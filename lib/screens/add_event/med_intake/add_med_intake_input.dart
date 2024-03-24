import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/models/med_intake_event.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';  // firstWhereOrNull

import '../../../helpers/date_time_helpers.dart';
import '../../../models/alarm.dart';

class AddMedIntakeInput extends StatefulWidget {
  final MedIntakeEvent? initMedIntakeEvent;
  final Alarm? initAlarm;

  const AddMedIntakeInput({
    super.key,
    this.initMedIntakeEvent,
    this.initAlarm,
  });

  @override
  State<AddMedIntakeInput> createState() => _AddMedIntakeInputState();
}

class _AddMedIntakeInputState extends State<AddMedIntakeInput> {
  late final List<DropdownMenuItem<Medication>> _medDropdownList;  // DropdownMenuItem is a generic, so we will assign it type that we need straight away.
  List<DropdownMenuItem<MeasureUnit>>? _unitDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate
  TextEditingController medicationQuantityController = TextEditingController();

  Medication? _inputMedication; // dropDown init value
  String? _inputMedicationQuantity; // Input ปริมาณ, will be parsed into double when OK is pressed
  MeasureUnit? _inputMeasureUnit;
  late DateTime _inputDate; // Date from datepicker
  late TimeOfDay _inputTime; // default time


  @override
  void initState() {
    super.initState();
    _medDropdownList = medicationEntries.map<DropdownMenuItem<Medication>>((entry) {
      return DropdownMenuItem<Medication>(
        value: entry,
        child: Text(entry.name),
      );
    }).toList();

    // _inputMedication = widget.initMedIntakeEvent == null ? null : medicationEntries.firstWhereOrNull((med) => med.name == widget.initMedIntakeEvent?.med);
    // _generateUnitDropdownList();  // Call this otherwise we'll need to reselect Medication to get unit drop down list
    //
    // // Date and time have their default values
    // if (widget.initMedIntakeEvent != null) {
    //   DateTime initTime = unixTimeToDateTime(widget.initMedIntakeEvent!.time);
    //   var r = separateDateTimeAndTimeOfDay(initTime);
    //   _inputDate = r.$1;
    //   _inputTime = r.$2;
    // } else {
    //   _inputDate = DateTime.now();
    //   _inputTime = TimeOfDay.now();
    // }

    if (widget.initMedIntakeEvent != null) {
      _inputMedication = medicationEntries.firstWhere((med) => med.name == widget.initMedIntakeEvent?.med);
      _generateUnitDropdownList();
      DateTime initTime = unixTimeToDateTime(widget.initMedIntakeEvent!.time);
      var r = separateDateTimeAndTimeOfDay(initTime);
      _inputDate = r.$1;
      _inputTime = r.$2;
    } else if (widget.initAlarm != null) {
      // If an initAlarm is passed it, will load the med/quantity/unit of it
      // But leave date and time to now.
      _inputMedication = medicationEntries.firstWhere((med) => med.name == widget.initAlarm?.med);
      _generateUnitDropdownList();

      _inputMedicationQuantity = widget.initAlarm!.quantity.toString();
      medicationQuantityController.text = _inputMedicationQuantity!;
      _inputMeasureUnit = _inputMedication!.medicationIntakeMethod.measureList.firstWhere((unit) => unit.measureName == widget.initAlarm!.unit);

      _inputDate = DateTime.now();
      _inputTime = TimeOfDay.now();
    } else {
      _inputDate = DateTime.now();
      _inputTime = TimeOfDay.now();
    }
  }

  /// TextEditingController requires disposing after use
  @override
  void dispose() {
    medicationQuantityController.dispose();
    super.dispose();
  }

  void _addToDb() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    // Parsing here shouldn't throw any errors since we used tryParse earlier in the validation function.
    double mgAmount = double.parse(_inputMedicationQuantity!)*_inputMedication!.medicationIntakeMethod.getMgPerUnit(_inputMeasureUnit!);
    MedIntakeEvent newMedIntakeEvent = MedIntakeEvent(medIntakeId: null, time: combinedUnixTime, med: _inputMedication!.name, mgAmount: mgAmount);
    DatabaseService.addMedIntakeEvent(newMedIntakeEvent);
  }

  void _updateToDb() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    double mgAmount = double.parse(_inputMedicationQuantity!)*_inputMedication!.medicationIntakeMethod.getMgPerUnit(_inputMeasureUnit!);
    MedIntakeEvent updateMedIntakeEvent = MedIntakeEvent(medIntakeId: widget.initMedIntakeEvent!.medIntakeId, time: combinedUnixTime, med: _inputMedication!.name, mgAmount: mgAmount);
    DatabaseService.addMedIntakeEvent(updateMedIntakeEvent);
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
                    HorizontalDatePicker(
                      selectedDate: _inputDate,
                      onDateChange: (date) {
                        setState(() {
                          _inputDate = date;
                        });
                      },
                    ),

                    Text("ชนิดของยาที่บันทึก", style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),

                    DropdownButtonFormField(
                      isExpanded: true,
                      value: _inputMedication,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (Medication? val) {
                        // 3 things that this onChange does
                        setState(() {
                          // 1) set the selectedMedication
                          _inputMedication = val!;
                          // 2) Update and clear the measure drop down menu
                          // use the ".?" operator to make the whole expr null if selectedMedication is null
                          _inputMeasureUnit = null;  // For some reason, not setting this to null will cause an assertion error saying that there are 0 or 2 duplicate entries in the unit's drop down menu.
                          _generateUnitDropdownList();
                          // 3) Clear medication quantity text field
                          _inputMedicationQuantity = null;
                          medicationQuantityController.clear();
                        });
                      },
                      items: _medDropdownList,
                      validator: (val) {
                        if (val == null) {
                          return "กรุณาเลือกยาที่จะบันทึก";
                        }
                      },
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
                                hintText: _inputTime.format(context),
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
                              initialTime: _inputTime,
                              initialEntryMode: TimePickerEntryMode.dial,
                            );
                            if (timeOfDay != null) {
                              setState(() {
                                _inputTime = timeOfDay;
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
                      crossAxisAlignment: CrossAxisAlignment.start,  // This is so that error msg from validator doesn't misalign the whole widget
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            // https://stackoverflow.com/questions/49577781/how-to-create-number-input-field-in-flutter & https://stackoverflow.com/a/61215563
                            controller: medicationQuantityController,
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
                            decoration: InputDecoration(
                                hintText: "ระบุปริมาณยา",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(width: kSmallPadding,),
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
                          },
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
                              if (widget.initMedIntakeEvent == null) {
                                _addToDb();
                              } else {
                                _updateToDb();
                              }
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
