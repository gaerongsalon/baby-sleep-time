import 'dart:math';

import '../../models/sleep_history.dart';
import '../../utils/date_converter.dart';
import '../store/store.dart';

Future<void> generateTestData() async {
  final rand = Random();
  final now = DateTime.now();
  var date = DateTime.now().add(Duration(days: -60));
  while (now.difference(date).inSeconds > 0) {
    final sleepHour = date.hour >= 20 || date.hour < 3
        ? 6 + rand.nextInt(2)
        : rand.nextInt(2);
    final helpSeconds = (5 + rand.nextInt(5)) * 60 + rand.nextInt(60);
    final sleepSeconds = sleepHour * 60 * 60 + 15 * 60 + rand.nextInt(30 * 60);
    print("[$date] help=$helpSeconds seconds, sleep=$sleepSeconds seconds.");

    final nextDate = date.add(Duration(seconds: helpSeconds + sleepSeconds));
    if (now.difference(nextDate).inSeconds <= 0) {
      break;
    }

    await getSleepHistoryDao().insertSleepHistory(SleepHistory(
        asyyyyMMdd(date), ashhmmss(date), helpSeconds, sleepSeconds));
    date = nextDate;
    final wakeUpMinutes = date.hour >= 0 && date.hour < 5
        ? 30 + rand.nextInt(30)
        : 90 + rand.nextInt(150);
    date = date.add(Duration(seconds: wakeUpMinutes * 60 + rand.nextInt(60)));
  }
}
