import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/sleep_history_dao.dart';

part 'sleep_history_database.g.dart';

@Database(version: 1, entities: [SleepHistory])
abstract class SleepHistoryDatabase extends FloorDatabase {
  SleepHistoryDao get sleepHistoryDao;
}
