import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/custom_widgets/seizure_occurrence_graph.dart';
import 'package:epilepsy_care_pmk/models/seizure_per_day.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:collection/collection.dart';

import 'package:epilepsy_care_pmk/main.dart';

buildPrintableSeizureHistory(List<SeizurePerDay> seizurePerDays) {
  // String? name = prefs.getString('firstName');
  // String? lastName = prefs.getString('lastName');
  String? hn = prefs.getString('hn');
  // total/max/min/avg calculation
  // int total = seizurePerDays.fold(0, (sum, element) => sum + element.seizureOccurrence);
  // fold is similar to reduce, but it can change type (reduce fixes the type to the same as the list)
  // Was going to use fold, but I think one for loop is better because otherwise, we'll have to do four sets of loops.

  // DateTime maxDate = seizurePerDays.first.date, minDate = seizurePerDays.first.date;
  int max = -1,
      min = -1 >>>
          1; // make max the lowest int, and min the highest int (I was going to make max == ~(-1 >>> 1), but scrapped that because it'd not work on the web (they convert all bitwise int to unsigned ints (https://dart.dev/guides/language/numbers#bitwise-operations))
  int total = 0;
  for (var s in seizurePerDays) {
    total += s.seizureOccurrence;

    if (max < s.seizureOccurrence) {
      max = s.seizureOccurrence;
      // maxDate = s.date;
    }

    if (min > s.seizureOccurrence) {
      min = s.seizureOccurrence;
      // minDate = s.date;
    }
  }
  double avg = total / seizurePerDays.length;
  return pw.Padding(
    padding: pw.EdgeInsets.all(kSmallPadding),
    child: pw.Flexible(
        child: pw.Column(
      children: [
        // TODO: Aggregate stats and display them accordingly.
        pw.Container(
          width: 340,
          decoration: pw.BoxDecoration(
              // color: pw.Color(0xFFF5F2FF),
              color: PdfColor.fromHex('F5F2FF'),
              borderRadius: pw.BorderRadius.circular(8)),
          child: pw.Padding(
            padding: pw.EdgeInsets.all(kLargePadding),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                      alignment: pw.Alignment.topLeft,
                      child: pw.Text("HN : $hn")),
                       pw.SizedBox(
                    height: kLargePadding,
                  ),
                pw.Row(children: [
                  pw.Text(
                    "Seizure Occurrence Statistics (${dateDateFormat.format(seizurePerDays.first.date)} - ${dateDateFormat.format(seizurePerDays.last.date)})",
                  )
                ]),
                pw.SizedBox(
                  height: kLargePadding,
                ),
                pw.Row(children: [
                  pw.Expanded(
                      child: pw.Text("Total Seizure Occurrence: ",
                          style: pw.TextStyle())),
                  pw.Text("$total Time(s)"),
                ]),
                pw.SizedBox(
                  height: kSmallPadding,
                ),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Text("Max Seizure Occurrence in a Day: "),
                  ),
                  pw.Text("$max Time(s)")
                ]),
                pw.SizedBox(
                  height: kSmallPadding,
                ),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Text("Min Seizure Occurrence in a Day: "),
                  ),
                  pw.Text("$min Time(s)")
                ]),
                pw.SizedBox(
                  height: kSmallPadding,
                ),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Text("Average Seizure Occurrence in a Day:"),
                  ),
                  pw.Text("${avg.toStringAsFixed(2)} Time(s)/Day")
                ]),
                pw.SizedBox(
                  height: kSmallPadding,
                ),
              ],
            ),
          ),
        ),
        // SeizureOccurrenceGraph(seizures: seizurePerDays),

        pw.SizedBox(
          height: 30,
        ),

        pw.Chart(
          right: pw.ChartLegend(),
          grid: pw.CartesianGrid(
            xAxis: pw.FixedAxis(
              List.generate(seizurePerDays.length, (index) => index),
              buildLabel: (i) {
                int index = i as int;
                if (index == 0) {
                  return
                  pw.Row(children:[
                    pw.SizedBox(width: 50),                    
                    pw.Text(
                      dateDateFormat.format(seizurePerDays[index].date))]); 
                  
                  
                } else if (index == seizurePerDays.length - 1) {
                  return pw.Text(
                      dateDateFormat.format(seizurePerDays[index].date));
                } else {
                  return pw.Text("");
                }
              },
            ),
            yAxis: pw.FixedAxis(
              List.generate(max + 2, (index) => index), // max +2
              divisions: true,
            ),
          ),
          datasets: [
            pw.LineDataSet(
                legend: 'Times',
                // drawSurface: true,
                isCurved: false,
                drawPoints: false,
                color: PdfColors.red,
                data: seizurePerDays
                    .mapIndexed<pw.PointChartValue>((index, element) =>
                        pw.PointChartValue(index.toDouble(),
                            element.seizureOccurrence.toDouble()))
                    .toList()),
          ],
        )
      ],
    )),
  );
}
