// import 'dart:js_interop_unsafe';

import 'package:epilepsy_care_pmk/constants/styling.dart';
import 'package:epilepsy_care_pmk/models/med_intake_per_day.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:collection/collection.dart';
import 'package:epilepsy_care_pmk/main.dart';

buildPrintableMedIntakeHistory(Medication m,
    List<MedIntakePerDay> medIntakePerDays, List<Medication> medKeys) {
  // String? name = prefs.getString('firstName');
  // String? lastName = prefs.getString('lastName');
  String? hn = prefs.getString('hn');

  // Aggregate basic stats
  if (medKeys.isNotEmpty) {
    double total = 0,
        avg = 0,
        max = double.negativeInfinity,
        min = double.infinity;
    for (MedIntakePerDay m in medIntakePerDays) {
      total += m.totalDose;

      if (max < m.totalDose) {
        max = m.totalDose;
      }

      if (min > m.totalDose) {
        min = m.totalDose;
      }
    }
    avg = total / medIntakePerDays.length;

    // These are used for graph rendering
    final int maxScale = max.ceil();
    const int scaleCount = 10;
    final int interval = maxScale ~/ scaleCount;
    List<int> scaleToDisplay = List.generate(scaleCount + 1, (index) => index*interval);

    return pw.Padding(
      padding: const pw.EdgeInsets.all(kSmallPadding),
      child: pw.Flexible(
        child: pw.Column(children: [
          pw.Container(
            decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('F5F2FF'),
                borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(kLargePadding),
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
                    pw.Expanded(
                      child: pw.Text(
                        "Medication Intake Statistics (${dateDateFormat.format(medIntakePerDays.first.date)} - ${dateDateFormat.format(medIntakePerDays.last.date)})",
                        // style: mediumLargeBoldText,
                      ),
                    )
                  ]),
                  pw.SizedBox(
                    height: kLargePadding,
                  ),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text("Medication Name: ${m.name}"))
                  ]),
                  pw.SizedBox(
                    height: kSmallPadding,
                  ),
                  // pw.Row(children: [
                  //   pw.Expanded(child: pw.Text("Dosage: ${m.medicationIntakeMethod}")) //TODO: Make Dosage Unit to ENG for PDF
                  // ]),
                  // pw.SizedBox(
                  //   height: kSmallPadding,
                  // ),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text("Total Amount Taken")),
                    pw.Text("${total.toStringAsFixed(2)} Mg."),
                  ]),
                  pw.SizedBox(
                    height: kSmallPadding,
                  ),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text("Max Amount Taken in a Day")),
                    pw.Text("${max.toStringAsFixed(2)} Mg."),
                  ]),
                  pw.SizedBox(
                    height: kSmallPadding,
                  ),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text("Min Amount Taken in a Day")),
                    pw.Text("${min.toStringAsFixed(2)} Mg."),
                  ]),
                  pw.SizedBox(
                    height: kSmallPadding,
                  ),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text("Average Amount Taken per Day")),
                    pw.Text("${avg.toStringAsFixed(2)} Mg./Days"),
                  ]),
                ],
              ),
            ),
          ),
          pw.SizedBox(
            height: kLargePadding,
          ),
          //Graph
          pw.Chart(
            right: pw.ChartLegend(),
            grid: pw.CartesianGrid(
              xAxis: pw.FixedAxis(
                List.generate(medIntakePerDays.length, (index) => index),
                buildLabel: (i) {
                  int index = i as int;
                  if (index == 0) {
                    return pw.Row(children: [
                      pw.SizedBox(width: 50),
                      pw.Text(
                          dateDateFormat.format(medIntakePerDays[index].date))
                    ]);
                  } else if (index == medIntakePerDays.length - 1) {
                    return pw.Text(
                        dateDateFormat.format(medIntakePerDays[index].date));
                  } else {
                    return pw.Text("");
                  }
                },
              ),
              yAxis: pw.FixedAxis(
                List.generate(max.ceil() + 2, (index) => index),
                buildLabel: (index) {
                  if (scaleToDisplay.contains(index)) {
                    return pw.Text(index.toString());
                  } else {
                    return pw.Text("");
                  }
                },
                divisions: true,
              ),
            ),
            datasets: [
              pw.LineDataSet(
                  legend: 'Dosage(Mg.)',
                  // drawSurface: true,
                  isCurved: false,
                  drawPoints: false,
                  color: PdfColors.red,
                  data: medIntakePerDays
                      .mapIndexed<pw.PointChartValue>((index, element) =>
                          pw.PointChartValue(
                              index.toDouble(), element.totalDose.toDouble()))
                      .toList()),
            ],
          )
        ]),
      ),
    );
  } else {
    return pw.Text("No History for record");
  }
}
