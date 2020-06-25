import 'package:baby_sleep_time/date_converter.dart';
import 'package:floor/floor.dart';
import 'package:meta/meta.dart';

@Entity(primaryKeys: ['yyyyMMdd', 'hhmmss'])
class SleepHistory {
  final int yyyyMMdd;
  final int hhmmss;

  final int helpSeconds;
  final int sleepSeconds;

  SleepHistory(this.yyyyMMdd, this.hhmmss, this.helpSeconds, this.sleepSeconds);

  DateTime get start => fromyyyyMMddhhmmss(yyyyMMdd, hhmmss);
}

SleepHistory newSleepHistory(
    {@required DateTime helpStart, @required DateTime sleepStart}) {
  return SleepHistory(
      asyyyyMMdd(helpStart),
      ashhmmss(helpStart),
      sleepStart.difference(helpStart).inSeconds,
      DateTime.now().difference(sleepStart).inSeconds);
}
