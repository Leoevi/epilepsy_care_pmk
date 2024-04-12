import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/models/alarm.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddAlarm extends StatefulWidget {
  final Alarm? initAlarm;

  const AddAlarm({
    super.key,
    this.initAlarm,
    required this.isGranted,
  });

  /// A variable that will determined whether or not the notification permission
  /// has been granted, will be used to determined the "enable" status of the
  /// new created notification.
  final bool isGranted;

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  late final List<DropdownMenuItem<Medication>> _medDropdownList;  // DropdownMenuItem is a generic, so we will assign it type that we need straight away.
  List<DropdownMenuItem<MeasureUnit>>? _unitDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate
  TextEditingController medicationQuantityController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Medication? _inputMedication; // dropDown init value
  String? _inputMedicationQuantity; // Input ปริมาณยา
  MeasureUnit? _inputMeasureUnit;
  TimeOfDay? _inputTime; // default time

  @override
  void initState() {
    super.initState();
    _medDropdownList = medicationEntries.map<DropdownMenuItem<Medication>>((entry) {
      return DropdownMenuItem<Medication>(
        value: entry,
        child: Text(entry.name),
      );
    }).toList();

    if (widget.initAlarm != null) {
      _inputMedication = medicationEntries.firstWhere((med) => med.name == widget.initAlarm?.med);
      _generateUnitDropdownList();

      _inputMedicationQuantity = widget.initAlarm!.quantity.toString();
      medicationQuantityController.text = _inputMedicationQuantity!;
      _inputMeasureUnit = _inputMedication!.medicationIntakeMethod.measureList.firstWhere((unit) => unit.measureName == widget.initAlarm!.unit);

      _inputTime = widget.initAlarm!.time;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // format method requires initState to be finished first. So we added a post frame callback.
        // (https://stackoverflow.com/questions/56395081/unhandled-exception-inheritfromwidgetofexacttype-localizationsscope-or-inheri)
        timeController.text = _inputTime!.format(context);
      });
    }
  }

  /// TextEditingController requires disposing after use
  @override
  void dispose() {
    medicationQuantityController.dispose();
    timeController.dispose();
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

                          Text("ชื่อยาที่บันทึก",
                              style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            isExpanded: true,
                            value: _inputMedication,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration: const InputDecoration(border: OutlineInputBorder()),
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

                          SizedBox(height: 20),

                          //Time
                          Text("โปรดกรอกเวลา", style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: timeController,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'กรุณาระบุเวลา';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
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
                                    initialTime: _inputTime ?? TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.dial,
                                  );
                                  if (timeOfDay != null) {
                                    setState(() {
                                      _inputTime = timeOfDay;
                                      timeController.text = _inputTime!.format(context);
                                    });
                                  }
                                },
                                style: primaryButtonStyle,
                              )
                            ],
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
