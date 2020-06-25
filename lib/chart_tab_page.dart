import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/generate_random_bar_chart_data.dart';
import 'package:baby_sleep_time/stacked_bar_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartTabPage extends StatefulWidget {
  const ChartTabPage({Key key}) : super(key: key);

  @override
  _ChartTabPageState createState() => _ChartTabPageState();
}

class _ChartTabPageState extends State<ChartTabPage> {
  List<BarChartGroupData> _data = [];
  bool _refresh = true;

  @override
  void initState() {
    super.initState();
    _data = generateRandomBarChartData();
    _startRefreshLoop();
  }

  @override
  void dispose() {
    _refresh = false;
    super.dispose();
  }

  Future _startRefreshLoop() async {
    while (_refresh) {
      await Future.delayed(Duration(seconds: 2));
      if (_refresh) {
        final newData = generateRandomBarChartData();
        setState(() {
          _data = newData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.BeigeColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text("Jun 2020",
                  style: TextStyle(fontSize: 24, color: Constants.IndigoColor)),
            ),
            StackedBarChart(
              data: _data,
            ),
          ],
        ),
      ),
    );
  }
}
