import 'package:baby_sleep_time/sleep_progress.dart';
import 'package:floor/floor.dart';

@dao
abstract class SleepProgressDao {
  @Query("SELECT * FROM SleepProgress LIMIT 1")
  Future<SleepProgress> findSleepProgress();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSleepProgress(SleepProgress progress);

  @Query("DELETE FROM SleepProgress")
  Future<void> deleteAllSleepProgresses();
}
