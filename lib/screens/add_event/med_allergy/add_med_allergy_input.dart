import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/med_allergy_event.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';  // firstWhereOrNull

class AddMedAllergyInput extends StatefulWidget {
  /// For launching this page with a pre-existing med allergy entry (for editing).
  /// Should be passed as null if this is a new allergy event entry.
  final MedAllergyEvent? initMedAllergyEvent;

  const AddMedAllergyInput({
    super.key,
    this.initMedAllergyEvent,
  });

  @override
  State<AddMedAllergyInput> createState() => _AddMedAllergyInputState();
}

class _AddMedAllergyInputState extends State<AddMedAllergyInput> {
  late final List<DropdownMenuItem<Medication>> medDropdownList;
  final _formKey = GlobalKey<FormState>(); //Validate

  Medication? _inputMedication; // dropDown init value
  String? _inputMedAllergySymptom; // Input อาการ
  DateTime _inputDate = DateTime.now(); // Date from datepicker
  TimeOfDay _inputTime = TimeOfDay.now();

  // load initMedAllergyEvent, if it exists
  @override
  void initState() {
    super.initState();
    medDropdownList = medicationEntries.map<DropdownMenuItem<Medication>>((entry) {
      return DropdownMenuItem<Medication>(
        value: entry,
        child: Text(entry.name),
      );
    }).toList();

    // Since we store Medication in DB as String, we need to find the actual
    // Medication object that corresponds to that String.
    _inputMedication = medicationEntries.firstWhereOrNull((med) => med.name == widget.initMedAllergyEvent?.med);
    _inputMedAllergySymptom = widget.initMedAllergyEvent?.medAllergySymptom;

    // Date and time have their default values
    if (widget.initMedAllergyEvent != null) {
      DateTime initTime = unixTimeToDateTime(widget.initMedAllergyEvent!.time);
      var r = separateDateTimeAndTimeOfDay(initTime);
      _inputDate = r.$1;
      _inputTime = r.$2;
    } else {
      _inputDate = DateTime.now();
      _inputTime = TimeOfDay.now();
    }
  }

  void _addToDb() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    MedAllergyEvent newMedAllergyEvent = MedAllergyEvent(medAllergyId: null, time: combinedUnixTime, med: _inputMedication!.name, medAllergySymptom: _inputMedAllergySymptom);
    DatabaseService.addMedAllergyEvent(newMedAllergyEvent);
  }

  void _updateToDb() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    MedAllergyEvent newMedAllergyEvent = MedAllergyEvent(medAllergyId: widget.initMedAllergyEvent!.medAllergyId, time: combinedUnixTime, med: _inputMedication!.name, medAllergySymptom: _inputMedAllergySymptom);
    DatabaseService.updateMedAllergyEvent(newMedAllergyEvent);
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
                      startDate: _inputDate,
                      onDateChange: (date) {
                        setState(() {
                          _inputDate = date;
                        });
                      },
                    ),

                    Text("ชนิดของยาที่เกิดอาการเเพ้ยา",
                        style: TextStyle(fontSize: 18)),

                    SizedBox(height: 10),

                    DropdownButtonFormField(
                      isExpanded: true, //https://stackoverflow.com/a/55376107
                      value: _inputMedication,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (Medication? val) {
                        setState(() {
                          _inputMedication = val!;
                          // print(dropDownValue);
                        });
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
                      initialValue: _inputMedAllergySymptom,
                      onChanged: (val) {
                        setState(() {
                          _inputMedAllergySymptom = val;
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
                              if (widget.initMedAllergyEvent == null) {
                                _addToDb();
                              } else {
                                _updateToDb();
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
          ),
        ),
      ),
    );
  }
}
