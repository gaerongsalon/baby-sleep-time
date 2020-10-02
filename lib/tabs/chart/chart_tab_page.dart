import 'package:flutter/material.dart';

import '../../components/date_header.dart';
import '../../services/chart/chart_data.dart';
import '../../services/chart/generate_chart_data.dart';
import '../../utils/date_converter.dart';
import 'components/stacked_bar_chart.dart';

class ChartTabPage extends StatefulWidget {
  const ChartTabPage({Key key}) : super(key: key);

  @override
  _ChartTabPageState createState() => _ChartTabPageState();
}

class _ChartTabPageState extends State<ChartTabPage> {
  List<ChartData> _data = [];
  int _yyyyMMdd = asyyyyMMdd(DateTime.now());

  @override
  void initState() {
    super.initState();
    _updateDate(asyyyyMMdd(DateTime.now()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1.color.withAlpha(255);
    final sleepColor = theme.accentColor.withAlpha(255);
    final helpColor = theme.hintColor.withAlpha(255);

    final averageSleepHours =
        calculateChartDataStat(_data, (d) => d.allSleepHours);
    final averageHelpMinutes =
        calculateChartDataStat(_data, (d) => d.allHelpHours * 60.0);
    final averageSleepCount =
        calculateChartDataStat(_data, (d) => d.sleepCount.toDouble());

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DateHeader(
              yyyyMMdd: _yyyyMMdd,
              onDateChanged: _updateDate,
            ),
            SizedBox(height: 24),
            Stack(children: [
              StackedBarChart(
                yyyyMMdd: _yyyyMMdd,
                chartData: _data,
                textColor: textColor,
                sleepColor: sleepColor,
                helpColor: helpColor,
              ),
              Positioned(
                top: 8,
                right: 12,
                child: Column(
                  children: [
                    _LegendLabel(color: helpColor, label: "도움"),
                    _LegendLabel(color: sleepColor, label: "수면"),
                  ],
                ),
              )
            ]),
            SizedBox(height: 10),
            Divider(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text.rich(TextSpan(
                  text: "지난 1주일간\n",
                  children: []
                    ..addAll(_buildStatText(
                        "수면 시간은", averageSleepHours, "시간", theme.accentColor))
                    ..addAll(_buildStatText(
                        "수면 횟수는", averageSleepCount, "번", theme.accentColor))
                    ..addAll(_buildStatText("도움 시간은", averageHelpMinutes,
                        "분 입니다.", theme.accentColor)),
                  style: TextStyle(fontSize: 20.0, height: 1.8))),
            )
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildStatText(
      String label, String value, String unit, Color valueColor) {
    return [
      // ignore: unnecessary_brace_in_string_interps
      TextSpan(text: "   평균 ${label} "),
      TextSpan(
          text: value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
      // ignore: unnecessary_brace_in_string_interps
      TextSpan(text: "${unit}\n"),
    ];
  }

  void _updateDate(int yyyyMMdd) async {
    // final theme = Theme.of(context);
    final newData = await generateChartData(
      yyyyMMdd: yyyyMMdd,
    );
    // sleepColor: theme.accentColor,
    // helpColor: theme.cardColor);
    setState(() {
      _yyyyMMdd = yyyyMMdd;
      _data = newData;
    });
  }
}

class _LegendLabel extends StatelessWidget {
  const _LegendLabel({
    Key key,
    @required this.color,
    @required this.label,
  }) : super(key: key);

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(color: color, height: 16, width: 16),
      SizedBox(width: 8),
      Text(label)
    ]);
  }
}
