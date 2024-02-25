import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../constants/styling.dart';

class DosageGraph extends StatefulWidget {
  const DosageGraph({
    super.key,
    required this.medIntakes,
  });

  final List<MedIntakePerDay> medIntakes;

  @override
  State<DosageGraph> createState() => _DosageGraphState();
}

class _DosageGraphState extends State<DosageGraph> {
  // The main obstacle here is the fact that fl_chart accepts only (double, double) x,y coords,
  // what we to plot here is (date, double), so we'll need to convert the dates into doubles.
  late List<FlSpot> medIntakeSpots;

  @override
  void initState() {
    super.initState();
    medIntakeSpots = widget.medIntakes.mapIndexed((index, element) => FlSpot(index.toDouble(), element.totalDose)).toList();
  }

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
      child: Text(dateDateFormat.format(widget.medIntakes[value.round()].date), style: style),
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
      color: Colors.yellow,
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
                    maxContentWidth: 100,
                    tooltipBgColor: Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${dateDateFormat.format(widget.medIntakes[touchedSpot.x.round()].date)}, ${touchedSpot.y.toStringAsFixed(2)}',
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
                    spots: medIntakeSpots,
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
                    // axisNameWidget: Text("ขนาดยา"),
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
                      reservedSize: 36,
                      interval: medIntakeSpots.length.toDouble(),
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
                  horizontalInterval: 1.5,
                  verticalInterval: 5,
                  checkToShowHorizontalLine: (value) {
                    return value.toInt() == 0;
                  },
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.blue,
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: Colors.yellow,
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  checkToShowVerticalLine: (value) {
                    return value.toInt() == 0;
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            );
          },
        ),
      ),
    );
  }
}


/// A class representing a point on the graph like so:
/// (DateTime, mg)
class MedIntakePerDay {
  final double totalDose;
  final DateTime date;

  MedIntakePerDay(this.totalDose, this.date);
}