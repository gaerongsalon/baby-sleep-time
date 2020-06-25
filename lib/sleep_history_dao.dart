import 'package:baby_sleep_time/sleep_history.dart';
import 'package:floor/floor.dart';

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

  @insert
  Future<void> insertSleepHistory(SleepHistory history);

  @delete
  Future<int> deleteSleepHistory(List<SleepHistory> histories);
}
