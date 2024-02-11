import 'package:flutter/material.dart';

// Didn't use because kept getting LateInitializationError
class TimeInput extends StatefulWidget {
  TimeInput({
    super.key,
    required this.onSelected,
  });

  final void Function(TimeOfDay) onSelected;

  TimeOfDay? selectedTime;

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  // To run exec some statements once, do it with initState
  // (https://stackoverflow.com/questions/61032975/how-to-ensure-code-is-run-only-once-in-a-widget)
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.selectedTime = TimeOfDay.now();
    });
  }

  // This widget has one minor bug, when hot reload, it'll cause
  // late initialization error
  // @override
  // void didUpdateWidget(TimeInput) {
  //   super.didUpdateWidget(TimeInput);
  //   widget.selectedTime = TimeOfDay.now();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    hintText: widget.selectedTime!.format(context),
                    // TODO: Change PM to 12-hour (https://stackoverflow.com/questions/70991271/flutter-dart-timeofday-object-returns-timeofday1500-instead-of-only-the-time)
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(width: 80),
            ElevatedButton(
              child: Text("เลือกเวลา",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white)),
              onPressed: () async {
                TimeOfDay? input =
                await showTimePicker(
                  context: context,
                  initialTime: widget.selectedTime!,
                  initialEntryMode: TimePickerEntryMode.dial,
                );
                setState(() {
                  widget.selectedTime = input ?? widget.selectedTime;  // Null checking syntax instead of ternary
                });
                widget.onSelected(widget.selectedTime!);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 201, 128, 247), //Color(0x7FCA80F7)
                  padding: EdgeInsets.all(20),
                  fixedSize: Size.fromWidth(140),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            )
          ],
        ),
      ],
    );
  }
}

