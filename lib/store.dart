import 'package:baby_sleep_time/sleep_history_dao.dart';
import 'package:baby_sleep_time/sleep_history_database.dart';

class Store {
  SleepHistoryDatabase database;

  Store();
}

var store = Store();

Future prepareStore() async {
  store.database = await $FloorSleepHistoryDatabase
      .databaseBuilder('app_database.db')
      .build();
}

SleepHistoryDao getSleepHistoryDao() {
  assert(store.database != null);
  return store.database.sleepHistoryDao;
}
