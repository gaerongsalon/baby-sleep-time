// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_history_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorSleepHistoryDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SleepHistoryDatabaseBuilder databaseBuilder(String name) =>
      _$SleepHistoryDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SleepHistoryDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SleepHistoryDatabaseBuilder(null);
}

class _$SleepHistoryDatabaseBuilder {
  _$SleepHistoryDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$SleepHistoryDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SleepHistoryDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SleepHistoryDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$SleepHistoryDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SleepHistoryDatabase extends SleepHistoryDatabase {
  _$SleepHistoryDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SleepHistoryDao _sleepHistoryDaoInstance;

  SleepProgressDao _sleepProgressDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SleepHistory` (`yyyyMMdd` INTEGER, `hhmmss` INTEGER, `helpSeconds` INTEGER, `sleepSeconds` INTEGER, PRIMARY KEY (`yyyyMMdd`, `hhmmss`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SleepProgress` (`id` INTEGER, `stateName` TEXT, `helpStartyyyyMMdd` INTEGER, `helpStarthhmmss` INTEGER, `sleepStartyyyyMMdd` INTEGER, `sleepStarthhmmss` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SleepHistoryDao get sleepHistoryDao {
    return _sleepHistoryDaoInstance ??=
        _$SleepHistoryDao(database, changeListener);
  }

  @override
  SleepProgressDao get sleepProgressDao {
    return _sleepProgressDaoInstance ??=
        _$SleepProgressDao(database, changeListener);
  }
}

class _$SleepHistoryDao extends SleepHistoryDao {
  _$SleepHistoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sleepHistoryInsertionAdapter = InsertionAdapter(
            database,
            'SleepHistory',
            (SleepHistory item) => <String, dynamic>{
                  'yyyyMMdd': item.yyyyMMdd,
                  'hhmmss': item.hhmmss,
                  'helpSeconds': item.helpSeconds,
                  'sleepSeconds': item.sleepSeconds
                }),
        _sleepHistoryUpdateAdapter = UpdateAdapter(
            database,
            'SleepHistory',
            ['yyyyMMdd', 'hhmmss'],
            (SleepHistory item) => <String, dynamic>{
                  'yyyyMMdd': item.yyyyMMdd,
                  'hhmmss': item.hhmmss,
                  'helpSeconds': item.helpSeconds,
                  'sleepSeconds': item.sleepSeconds
                }),
        _sleepHistoryDeletionAdapter = DeletionAdapter(
            database,
            'SleepHistory',
            ['yyyyMMdd', 'hhmmss'],
            (SleepHistory item) => <String, dynamic>{
                  'yyyyMMdd': item.yyyyMMdd,
                  'hhmmss': item.hhmmss,
                  'helpSeconds': item.helpSeconds,
                  'sleepSeconds': item.sleepSeconds
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _sleepHistoryMapper = (Map<String, dynamic> row) => SleepHistory(
      row['yyyyMMdd'] as int,
      row['hhmmss'] as int,
      row['helpSeconds'] as int,
      row['sleepSeconds'] as int);

  final InsertionAdapter<SleepHistory> _sleepHistoryInsertionAdapter;

  final UpdateAdapter<SleepHistory> _sleepHistoryUpdateAdapter;

  final DeletionAdapter<SleepHistory> _sleepHistoryDeletionAdapter;

  @override
  Future<List<SleepHistory>> findAllSleepHistories() async {
    return _queryAdapter.queryList('SELECT * FROM SleepHistory',
        mapper: _sleepHistoryMapper);
  }

  @override
  Future<List<SleepHistory>> findSleepHistoriesByDate(int yyyyMMdd) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SleepHistory WHERE yyyyMMdd = ? ORDER BY yyyyMMdd DESC, hhmmss DESC',
        arguments: <dynamic>[yyyyMMdd],
        mapper: _sleepHistoryMapper);
  }

  @override
  Future<SleepHistory> findLastSleepHistory() async {
    return _queryAdapter.query(
        'SELECT * FROM SleepHistory ORDER BY yyyyMMdd DESC, hhmmss DESC LIMIT 1',
        mapper: _sleepHistoryMapper);
  }

  @override
  Future<SleepHistory> findFirstSleepHistory() async {
    return _queryAdapter.query(
        'SELECT * FROM SleepHistory ORDER BY yyyyMMdd ASC, hhmmss ASC LIMIT 1',
        mapper: _sleepHistoryMapper);
  }

  @override
  Future<void> insertSleepHistory(SleepHistory history) async {
    await _sleepHistoryInsertionAdapter.insert(
        history, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSleepHistory(SleepHistory history) async {
    await _sleepHistoryUpdateAdapter.update(history, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSleepHistory(List<SleepHistory> histories) {
    return _sleepHistoryDeletionAdapter
        .deleteListAndReturnChangedRows(histories);
  }
}

class _$SleepProgressDao extends SleepProgressDao {
  _$SleepProgressDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sleepProgressInsertionAdapter = InsertionAdapter(
            database,
            'SleepProgress',
            (SleepProgress item) => <String, dynamic>{
                  'id': item.id,
                  'stateName': item.stateName,
                  'helpStartyyyyMMdd': item.helpStartyyyyMMdd,
                  'helpStarthhmmss': item.helpStarthhmmss,
                  'sleepStartyyyyMMdd': item.sleepStartyyyyMMdd,
                  'sleepStarthhmmss': item.sleepStarthhmmss
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _sleepProgressMapper = (Map<String, dynamic> row) =>
      SleepProgress(
          row['id'] as int,
          row['stateName'] as String,
          row['helpStartyyyyMMdd'] as int,
          row['helpStarthhmmss'] as int,
          row['sleepStartyyyyMMdd'] as int,
          row['sleepStarthhmmss'] as int);

  final InsertionAdapter<SleepProgress> _sleepProgressInsertionAdapter;

  @override
  Future<SleepProgress> findSleepProgress() async {
    return _queryAdapter.query('SELECT * FROM SleepProgress LIMIT 1',
        mapper: _sleepProgressMapper);
  }

  @override
  Future<void> deleteAllSleepProgresses() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SleepProgress');
  }

  @override
  Future<void> insertSleepProgress(SleepProgress progress) async {
    await _sleepProgressInsertionAdapter.insert(
        progress, OnConflictStrategy.replace);
  }
}
