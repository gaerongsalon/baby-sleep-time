import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/chart/chart_data.dart';
import '../../../utils/date_converter.dart';

class StackedBarChart extends StatelessWidget {
  final int yyyyMMdd;
  final List<ChartData> chartData;
  final Color textColor;
  final Color sleepColor;
  final Color helpColor;
  final bool tip;

  StackedBarChart({
    Key key,
    @required this.yyyyMMdd,
    @required this.chartData,
    @required this.textColor,
    @required this.sleepColor,
    @required this.helpColor,
    this.tip = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: tip ? 1.4 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: 16,
            barTouchData: BarTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(color: textColor, fontSize: 10),
                margin: 10,
                getTitles: (double value) {
                  return DateFormat.MMMd().format(fromyyyyMMdd(yyyyMMdd)
                      .add(Duration(days: value.toInt() - 6)));
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(color: textColor, fontSize: 10),
                getTitles: (double value) {
                  return value.toInt().toString();
                },
                interval: 2,
                margin: 0,
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (value) => value % 10 == 0,
              getDrawingHorizontalLine: (value) => FlLine(
                color: textColor,
                strokeWidth: 5,
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: _generateChartGroupData(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateChartGroupData() {
    final data = <BarChartGroupData>[];
    var x = 0;
    for (final each in chartData) {
      data.add(BarChartGroupData(x: x, barRods: [
        BarChartRodData(
            y: each.allSleepHours + each.allHelpHours,
            width: 40,
            rodStackItems: [
              BarChartRodStackItem(0, each.allSleepHours, sleepColor),
              BarChartRodStackItem(each.allSleepHours,
                  each.allSleepHours + each.allHelpHours, helpColor),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5.0)))
      ]));
      ++x;
    }
    return data;
  }
}
