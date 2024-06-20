import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/horizontal_date_picker.dart';
import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/med_allergy_event.dart';
import 'package:epilepsy_care_pmk/screens/commons/screen_with_app_bar.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:epilepsy_care_pmk/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../custom_widgets/medication_selection_form.dart';
import '../../../custom_widgets/time_of_day_dropdown.dart';  // firstWhereOrNull

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
  final _formKey = GlobalKey<FormState>(); //Validate

  Medication? _inputMedication; // dropDown init value
  String? _inputMedAllergySymptom; // Input อาการ
  DateTime _inputDate = DateTime.now(); // Date from datepicker
  TimeOfDay _inputTime = TimeOfDay.now();

  // load initMedAllergyEvent, if it exists
  @override
  void initState() {
    super.initState();

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
    MedAllergyEvent newMedAllergyEvent = MedAllergyEvent(medAllergyId: null, time: combinedUnixTime, med: _inputMedication!.name, medAllergySymptom: _inputMedAllergySymptom!);
    DatabaseService.addMedAllergyEvent(newMedAllergyEvent);
  }

  void _updateToDb() {
    int combinedUnixTime = dateTimeToUnixTime(combineDateTimeWithTimeOfDay(_inputDate, _inputTime));
    MedAllergyEvent newMedAllergyEvent = MedAllergyEvent(medAllergyId: widget.initMedAllergyEvent!.medAllergyId, time: combinedUnixTime, med: _inputMedication!.name, medAllergySymptom: _inputMedAllergySymptom!);
    DatabaseService.updateMedAllergyEvent(newMedAllergyEvent);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithAppBar(
      title: widget.initMedAllergyEvent == null ? "บันทึกอาการเเพ้ยา" : "แก้ไขอาการแพ้ยา",
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
                    HorizontalDatePicker(
                      selectedDate: _inputDate,
                      onDateChange: (date) {
                        setState(() {
                          _inputDate = date;
                        });
                      },
                    ),

                    const Text("ชนิดของยาที่เกิดอาการเเพ้ยา",
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
                            _inputMedication = newMed;
                          });
                        }),

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

                    const Text("โปรดระบุอาการ", style: TextStyle(fontSize: 18)),

                    const SizedBox(height: 10),
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
                      decoration: const InputDecoration(
                          hintText: "ระบุอาการ", border: OutlineInputBorder()),
                    ),

                    const SizedBox(height: 80),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: secondaryButtonStyle,
                          child: const Text("ยกเลิก", style: TextStyle(fontSize: 16)),
                        ),
                        ElevatedButton(
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
                                      content: const Text('บันทึกข้อมูลสำเร็จ')));
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
                          child: const Text("ตกลง",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
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
