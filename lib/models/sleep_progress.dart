import 'package:floor/floor.dart';
import 'package:meta/meta.dart';

import '../utils/date_converter.dart';
import 'watch_state.dart';

@Entity(primaryKeys: ['id'])
class SleepProgress {
  final int id;

  final String stateName;
  final int helpStartyyyyMMdd;
  final int helpStarthhmmss;
  final int sleepStartyyyyMMdd;
  final int sleepStarthhmmss;

  SleepProgress(this.id, this.stateName, this.helpStartyyyyMMdd,
      this.helpStarthhmmss, this.sleepStartyyyyMMdd, this.sleepStarthhmmss);

  WatchState get state => WatchState.values
      .firstWhere((element) => element.toString() == stateName);

  DateTime get helpStart => helpStartyyyyMMdd == 0
      ? null
      : fromyyyyMMddhhmmss(helpStartyyyyMMdd, helpStarthhmmss);

  DateTime get sleepStart => sleepStartyyyyMMdd == 0
      ? null
      : fromyyyyMMddhhmmss(sleepStartyyyyMMdd, sleepStarthhmmss);
}

SleepProgress newSleepProgress(
    {@required WatchState state,
    @required DateTime helpStart,
    @required DateTime sleepStart}) {
  return SleepProgress(
      1, // Only one entity in there.
      state.toString(),
      helpStart != null ? asyyyyMMdd(helpStart) : 0,
      helpStart != null ? ashhmmss(helpStart) : 0,
      sleepStart != null ? asyyyyMMdd(sleepStart) : 0,
      sleepStart != null ? ashhmmss(sleepStart) : 0);
}
