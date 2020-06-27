import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/sleep_history_dao.dart';
import 'package:baby_sleep_time/sleep_history_database.dart';
import 'package:baby_sleep_time/sleep_progress_dao.dart';
import 'package:floor/floor.dart';

class Store {
  SleepHistoryDatabase database;
  SleepHistory firstHistory;
  SleepHistory lastHistory;

  Store();
}

var store = Store();

Future prepareStore() async {
  final migration1to2 = Migration(1, 2, (database) async {
    // Add a new table: SleepProgress
  });

  store.database = await $FloorSleepHistoryDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([migration1to2]).build();
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
