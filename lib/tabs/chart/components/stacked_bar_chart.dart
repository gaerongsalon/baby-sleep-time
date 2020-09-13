import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StackedBarChart extends StatelessWidget {
  final List<BarChartGroupData> data;

  StackedBarChart({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 45,
            barTouchData: BarTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle:
                    const TextStyle(color: Color(0xff939393), fontSize: 10),
                margin: 10,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Apr';
                    case 1:
                      return 'May';
                    case 2:
                      return 'Jun';
                    case 3:
                      return 'Jul';
                    case 4:
                      return 'Aug';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: const TextStyle(
                    color: Color(
                      0xff939393,
                    ),
                    fontSize: 10),
                getTitles: (double value) {
                  return value.toInt().toString();
                },
                interval: 10,
                margin: 0,
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (value) => value % 10 == 0,
              getDrawingHorizontalLine: (value) => FlLine(
                color: const Color(0xffe7e8ec),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            groupsSpace: 4,
            barGroups: data,
          ),
        ),
      ),
    );
  }
}
