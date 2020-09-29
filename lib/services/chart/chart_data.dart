import 'package:intl/intl.dart';

class ChartData {
  final DateTime date;
  final double allHelpHours;
  final double allSleepHours;
  final int sleepCount;

  ChartData(this.date, this.allHelpHours, this.allSleepHours, this.sleepCount);
}

final _numberFormat = NumberFormat("#.#");

String calculateChartDataStat(
    List<ChartData> data, double Function(ChartData) getter) {
  if (data == null || data.length == 0) {
    return "0";
  }
  return _numberFormat.format(data.fold(
          0.0, (previousValue, element) => previousValue + getter(element)) /
      data.length.toDouble());
}
