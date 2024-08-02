import 'dart:math';

import 'package:epilepsy_care_pmk/models/seizure_per_day.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../constants/styling.dart';

// Somehow, using StatefulWidget makes the graph not change, and we have to use StatelessWidget instead
class SeizureOccurrenceGraph extends StatelessWidget {
  // Can't be const because we have a late final field.
  SeizureOccurrenceGraph({
    super.key,
    required this.seizures,
  });

  final List<SeizurePerDay> seizures;

  // The main obstacle here is the fact that fl_chart accepts only (double, double) x,y coords,
  late final List<FlSpot> seizureSpots;

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );

    return SideTitleWidget(
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0),  // make the SideTitle not overflow over the edges
      axisSide: meta.axisSide,
      space: 16,
      child: Text(DateFormat.yMMMd(locale).format(seizures[value.round()].date), style: style),
    );

    // Instead of doing logic here, we will use interval instead
    // if (value.round() == 0 || value.round() == arrLength - 1) {
    //   return SideTitleWidget(
    //     axisSide: meta.axisSide,
    //     space: 16,
    //     child: Text(meta.formattedValue, style: style),
    //   );
    // } else {
    //   return Container();
    // }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    seizureSpots = seizures.mapIndexed((index, element) => FlSpot(index.toDouble(), element.seizureOccurrence.toDouble())).toList();
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        bottom: 12,
        right: 20,
        top: 20,
      ),
      child: AspectRatio(
        aspectRatio: 2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    maxContentWidth: 100,
                    getTooltipColor: (LineBarSpot touchedSpot) => Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${DateFormat.yMMMd(locale).format(seizures[touchedSpot.x.round()].date)}, ${touchedSpot.y.toStringAsPrecision(1)} ครั้ง',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: Colors.pink,
                    spots: seizureSpots,
                    isCurved: false,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
                minY: 0,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    // axisNameWidget: Text("ครั้ง"),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          leftTitleWidgets(value, meta, constraints.maxWidth),
                      reservedSize: 56,
                    ),
                    drawBelowEverything: true,
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    // axisNameWidget: Text("วันที่"),  // Need space, so will just use one label on top
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          bottomTitleWidgets(value, meta, constraints.maxWidth),
                      reservedSize: 38,
                      interval: seizureSpots.length.toDouble(),
                    ),
                    drawBelowEverything: true,
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Colors.black,
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  getDrawingVerticalLine: (_) => const FlLine(
                    color: Colors.black,
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                ),
                borderData: FlBorderData(show: true),
              ),
            );
          },
        ),
      ),
    );
  }
}
