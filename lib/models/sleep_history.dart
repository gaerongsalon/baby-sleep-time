import 'package:floor/floor.dart';
import 'package:meta/meta.dart';

import '../utils/date_converter.dart';

@Entity(primaryKeys: ['yyyyMMdd', 'hhmmss'])
class SleepHistory {
  final int yyyyMMdd;
  final int hhmmss;

  final int helpSeconds;
  final int sleepSeconds;

  SleepHistory(this.yyyyMMdd, this.hhmmss, this.helpSeconds, this.sleepSeconds);

  DateTime get start => fromyyyyMMddhhmmss(yyyyMMdd, hhmmss);
  DateTime get sleepStart => start.add(helpDuration);
  DateTime get sleepEnd => start.add(totalDuration);

  Duration get helpDuration => Duration(seconds: helpSeconds);
  Duration get sleepDuration => Duration(seconds: sleepSeconds);
  Duration get totalDuration => Duration(seconds: helpSeconds + sleepSeconds);

  int get hour => hhmmss ~/ 10000;
}

SleepHistory newSleepHistory(
    {@required DateTime helpStart, @required DateTime sleepStart}) {
  return SleepHistory(
      asyyyyMMdd(helpStart),
      ashhmmss(helpStart),
      sleepStart.difference(helpStart).inSeconds,
      DateTime.now().difference(sleepStart).inSeconds);
}
