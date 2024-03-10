import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../custom_widgets/time_range_dropdown_button.dart';
import '../../../models/med_intake_per_day.dart';
import '../../../services/database_service.dart';
import '../../wiki/medication/medication.dart';

class MedIntakeHistory extends StatefulWidget {
  const MedIntakeHistory({super.key});

  @override
  State<MedIntakeHistory> createState() => _MedIntakeHistoryState();
}

class _MedIntakeHistoryState extends State<MedIntakeHistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(kSmallPadding),
            child: Row(
                mainAxisAlignment:
                MainAxisAlignment.end,
                children: [TimeRangeDropdownButton()])),
        Container(
          width: 340,
          decoration: BoxDecoration(
              color: Color(0xFFF5F2FF),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(kLargePadding),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    "ข้อมูลบันทึกกินยา",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  )
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(children: [Text("ชื่อยา")]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [Text("ขนาด")]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [Text("---------")]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [Text("---------")]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [Text("---------")]),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FutureBuilder(
          future: DatabaseService
              .getAllMedIntakePerDayFrom(
              DateTimeRange(
                  start: DateTime(2023, 12, 1),
                  end: DateTime(2024, 3, 1))),
          // TODO: implement filter and sorting
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Text(
                      "Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  Iterable<MapEntry<Medication, List<MedIntakePerDay>>> entries = snapshot.data!.entries;
                  for (MapEntry e in entries) {
                    print(e);
                  }
                  return Text("bruh");
                } else {
                  return Column(
                    children: [
                      Text("No data, but..."),
                      Text("${snapshot.data}")
                    ],
                  );
                }
            }
          },
        )
      ],
    );
  }
}
