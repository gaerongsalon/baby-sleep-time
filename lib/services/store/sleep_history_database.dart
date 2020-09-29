import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/sleep_history.dart';
import '../../models/sleep_progress.dart';
import 'sleep_history_dao.dart';
import 'sleep_progress_dao.dart';

part 'sleep_history_database.g.dart';

@Database(version: 1, entities: [SleepHistory, SleepProgress])
abstract class SleepHistoryDatabase extends FloorDatabase {
  SleepHistoryDao get sleepHistoryDao;
  SleepProgressDao get sleepProgressDao;
}
