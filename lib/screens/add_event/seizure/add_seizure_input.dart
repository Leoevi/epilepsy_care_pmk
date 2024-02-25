import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/seizure_event.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/horizontal_date_picker.dart';

const List<String> seizureTypes = <String>['ชักทั้งตัว', 'ชักเฉพาะ', 'เหม่อลอย', 'อื่นๆ'];

class AddSeizureInput extends StatefulWidget {
  /// For launching this page with a pre-existing seizure entry (for editing).
  /// Should be passed as null if this is a new seizure event entry.
  final SeizureEvent? initSeizureEvent;

  const AddSeizureInput({
    super.key,
    this.initSeizureEvent,
  });

  @override
  State<AddSeizureInput> createState() => _AddSeizureInputState();
}

class _AddSeizureInputState extends State<AddSeizureInput> {
  final _formKey = GlobalKey<FormState>(); //Validate

  String? _inputSeizureSymptom; // Input อาการ
  String? _inputSeizurePlace; // Input สถานที่
  String? _inputSeizureType;
  late DateTime _inputDate; // Date from DatePicker
  late TimeOfDay _inputTime; // Time from TimePicker

  // load initSeizureEvent, if it exists
  @override
  void initState() {
    super.initState();
    _inputSeizureSymptom = widget.initSeizureEvent?.seizureSymptom;
    _inputSeizurePlace = widget.initSeizureEvent?.seizurePlace;
    _inputSeizureType = widget.initSeizureEvent?.seizureType;

    // Date and time have their default values
    if (widget.initSeizureEvent != null) {
      DateTime initTime = unixTimeToDateTime(widget.initSeizureEvent!.time);
      var r = separateDateTimeAndTimeOfDay(initTime);
      _inputDate = r.$1;
      _inputTime = r.$2;
    } else {
      _inputDate = DateTime.now();
      _inputTime = TimeOfDay.now();
    }
  }

  // For creating new seizureEvent
  void addToDB() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    // null on primary key for auto-increment (https://stackoverflow.com/questions/7905859/is-there-auto-increment-in-sqlite)
    SeizureEvent newSeizureEvent = SeizureEvent(seizureId: null, time: combinedUnixTime, seizureType: _inputSeizureType!, seizureSymptom: _inputSeizureSymptom, seizurePlace: _inputSeizurePlace!);
    DatabaseService.addSeizureEvent(newSeizureEvent);
  }

  // For editing an already existing seizureEvent
  void updateToDB() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    SeizureEvent updatedSeizureEvent = SeizureEvent(seizureId: widget.initSeizureEvent!.seizureId, time: combinedUnixTime, seizureType: _inputSeizureType!, seizureSymptom: _inputSeizureSymptom, seizurePlace: _inputSeizurePlace!);
    DatabaseService.updateSeizureEvent(updatedSeizureEvent);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
        title: widget.initSeizureEvent == null ? "บันทึกอาการลมชัก" : "แก้ไขอาการลมชัก",
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
                            startDate: _inputDate,
                            onDateChange: (date) {
                              setState(() {
                                _inputDate = date;
                              });
                            },
                          ),

                          Text("เพิ่มอาการชัก", style: TextStyle(fontSize: 18)),

                          SizedBox(height: 10),

                          DropdownButtonFormField(
                            value: _inputSeizureType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            onChanged: (String? val) {
                              setState(() {
                                _inputSeizureType = val!;
                              });
                            },
                            items: seizureTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 20),

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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
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
                            initialValue: _inputSeizureSymptom,  // For loading from an existing seizureEvent (if null then the field will be empty, just like normal)
                            // Could also use TextEditingController, but initialValue is more concise (https://stackoverflow.com/questions/46481638/how-to-properly-pre-fill-flutter-form-field)
                            onChanged: (val) {
                              setState(() {
                                _inputSeizureSymptom = val;
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
                            initialValue: _inputSeizurePlace,
                            onChanged: (val) {
                              setState(() {
                                _inputSeizurePlace = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "ระบุสถานที่",
                                border: OutlineInputBorder()),
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
                                style: secondaryButtonStyle,
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
                                    if (widget.initSeizureEvent == null) {
                                      addToDB();
                                    } else {
                                      updateToDB();
                                    }
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
