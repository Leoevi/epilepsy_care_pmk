import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:flutter/material.dart';

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class TimeRangeDropdown extends StatefulWidget {
  const TimeRangeDropdown({super.key});

  @override
  State<TimeRangeDropdown> createState() => _TimeRangeDropdownState();
}

class _TimeRangeDropdownState extends State<TimeRangeDropdown> {
  var dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 3),
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['7 วัน', '30 วัน', '90 วัน']   //dropdown item 
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



// DropdownMenu<String>(
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       textStyle: TextStyle(fontSize: 15),
//       initialSelection: list.first,
//       onSelected: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );