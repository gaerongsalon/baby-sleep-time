import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/date_converter.dart';
import '../../services/generator/generate_random_bar_chart_data.dart';
import '../../components/date_header.dart';
import 'components/stacked_bar_chart.dart';

class ChartTabPage extends StatefulWidget {
  const ChartTabPage({Key key}) : super(key: key);

  @override
  _ChartTabPageState createState() => _ChartTabPageState();
}

class _ChartTabPageState extends State<ChartTabPage> {
  List<BarChartGroupData> _data = [];
  bool _refresh = true;
  int _yyyyMMdd = asyyyyMMdd(DateTime.now());

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
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DateHeader(
              yyyyMMdd: _yyyyMMdd,
              onDateChanged: _updateDate,
            ),
            StackedBarChart(
              data: _data,
            ),
          ],
        ),
      ),
    );
  }

  void _updateDate(int yyyyMMdd) {
    setState(() {
      _yyyyMMdd = yyyyMMdd;
    });
  }
}
