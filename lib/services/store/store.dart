import 'package:floor/floor.dart';

import '../../models/sleep_history.dart';
import 'sleep_history_dao.dart';
import 'sleep_history_database.dart';
import 'sleep_progress_dao.dart';

class Store {
  SleepHistoryDatabase database;
  SleepHistory firstHistory;
  SleepHistory lastHistory;

  Store();
}

var store = Store();

Future prepareStore() async {
  store.database = await $FloorSleepHistoryDatabase
      .databaseBuilder('sleeptime_v1.db')
      .build();
  store.firstHistory =
      await store.database.sleepHistoryDao.findFirstSleepHistory();
  store.lastHistory =
      await store.database.sleepHistoryDao.findLastSleepHistory();
}

SleepHistoryDao getSleepHistoryDao() {
  assert(store.database != null);
  return store.database.sleepHistoryDao;
}

SleepProgressDao getSleepProgressDao() {
  assert(store.database != null);
  return store.database.sleepProgressDao;
}

SleepHistory getFirstSleepHistory() {
  return store.firstHistory;
}

SleepHistory getLastSleepHistory() {
  return store.lastHistory;
}

void updateLastSleepHistory(SleepHistory lastHistory) {
  store.lastHistory = lastHistory;
}
