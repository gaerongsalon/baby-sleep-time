import 'package:floor/floor.dart';

import '../../models/sleep_history.dart';

@dao
abstract class SleepHistoryDao {
  @Query("SELECT * FROM SleepHistory")
  Future<List<SleepHistory>> findAllSleepHistories();

  @Query(
      "SELECT * FROM SleepHistory WHERE yyyyMMdd = :yyyyMMdd ORDER BY yyyyMMdd DESC, hhmmss DESC")
  Future<List<SleepHistory>> findSleepHistoriesByDate(int yyyyMMdd);

  @Query(
      "SELECT * FROM SleepHistory ORDER BY yyyyMMdd DESC, hhmmss DESC LIMIT 1")
  Future<SleepHistory> findLastSleepHistory();

  @Query("SELECT * FROM SleepHistory ORDER BY yyyyMMdd ASC, hhmmss ASC LIMIT 1")
  Future<SleepHistory> findFirstSleepHistory();

  @insert
  Future<void> insertSleepHistory(SleepHistory history);

  @update
  Future<void> updateSleepHistory(SleepHistory history);

  @delete
  Future<int> deleteSleepHistory(List<SleepHistory> histories);

  @Query("DELETE FROM SleepHistory")
  Future<void> deleteAllSleepHistories();
}
