import '../../utils/date_converter.dart';
import '../store/store.dart';
import 'chart_data.dart';

Future<List<ChartData>> generateChartData(
    {int yyyyMMdd, int spanDays = 7}) async {
  final targetDate = fromyyyyMMdd(yyyyMMdd);
  final data = <ChartData>[];
  for (int x = 0; x < spanDays; ++x) {
    final date = targetDate.add(Duration(days: x - spanDays + 1));
    final histories =
        await getSleepHistoryDao().findSleepHistoriesByDate(asyyyyMMdd(date));
    final allHelpHours = histories.fold(0,
            (previousValue, element) => previousValue + element.helpSeconds) /
        3600.0;
    final allSleepHours = histories.fold(0,
            (previousValue, element) => previousValue + element.sleepSeconds) /
        3600.0;
    data.add(ChartData(date, allHelpHours, allSleepHours, histories.length));
  }
  return data;
}
