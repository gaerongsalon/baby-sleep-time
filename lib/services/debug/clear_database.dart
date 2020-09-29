import '../store/store.dart';

Future<void> clearDatabase() async {
  await getSleepHistoryDao().deleteAllSleepHistories();
}
