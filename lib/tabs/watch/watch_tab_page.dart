import 'package:flutter/material.dart';

import '../../components/circle_button.dart';
import '../../components/loading_page.dart';
import '../../components/prompt_dialog.dart';
import '../../components/sleep_time_log.dart';
import '../../models/sleep_history.dart';
import '../../models/sleep_progress.dart';
import '../../models/watch_state.dart';
import '../../services/debug/clear_database.dart';
import '../../services/debug/generate_test_data.dart';
import '../../services/store/store.dart';
import 'components/clock.dart';

class WatchTabPage extends StatefulWidget {
  const WatchTabPage({Key key}) : super(key: key);

  @override
  _WatchTabPageState createState() => _WatchTabPageState();
}

class _WatchTabPageState extends State<WatchTabPage>
    with AutomaticKeepAliveClientMixin<WatchTabPage> {
  WatchState _state = WatchState.Ready; // Load last state

  DateTime _helpStart;
  DateTime _sleepStart;

  bool _loading = false;
  SleepHistory _lastHistory;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    final lastHistory = await getSleepHistoryDao().findLastSleepHistory();
    final progress = await getSleepProgressDao().findSleepProgress();
    setState(() {
      _lastHistory = lastHistory;
      if (progress != null) {
        _state = progress.state;
        _helpStart = progress.helpStart;
        _sleepStart = progress.sleepStart;
      } else {
        _state = WatchState.Ready;
      }
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_loading) {
      return LoadingPage();
    }
    return Container(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onLongPress: () => _debugAction(context, generateTestData),
              child: _buildTitle()),
          GestureDetector(
              onLongPress: () => _debugAction(context, _clearDatabase),
              child: _buildClock()),
          _buildActionButtons(),
          _buildLastHistory(),
        ],
      )),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Text(
        _state == WatchState.Ready
            ? "수면의식 시작해볼까요?"
            : _state == WatchState.Help ? "아이를 믿고 기다려봐요." : "수고했어요!",
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildClock() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Clock(
        startTime: _state == WatchState.Ready
            ? DateTime.now()
            : _state == WatchState.Help ? _helpStart : _sleepStart,
        initialGoing: _state != WatchState.Ready,
      ),
    );
  }

  Widget _buildActionButtons() {
    final actionButton = CircleButton(
      icon: _buildActionIcon(),
      onPressed: _changeState,
    );
    final cancelButton = CircleButton(
      icon: Icons.highlight_off,
      onPressed: _clearSleepContext,
    );
    return _state == WatchState.Ready
        ? actionButton
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cancelButton, actionButton],
          );
  }

  IconData _buildActionIcon() {
    return _state == WatchState.Ready
        ? Icons.play_arrow
        : _state == WatchState.Help
            ? Icons.airline_seat_individual_suite
            : Icons.assistant_photo;
  }

  Widget _buildLastHistory() {
    return _state != WatchState.Ready
        ? SleepTimeLog(
            startTime: _helpStart,
            helpSeconds: _sleepStart != null
                ? _sleepStart.difference(_helpStart).inSeconds
                : -1,
            sleepSeconds: -1,
          )
        : _lastHistory != null
            ? SleepTimeLog(
                startTime: _lastHistory.start,
                helpSeconds: _lastHistory.helpSeconds,
                sleepSeconds: _lastHistory.sleepSeconds,
              )
            : Container();
  }

  void _changeState() {
    switch (_state) {
      case WatchState.Ready:
        setState(() {
          _helpStart = DateTime.now();
          _state = WatchState.Help;
        });
        getSleepProgressDao().insertSleepProgress(newSleepProgress(
            state: _state, helpStart: _helpStart, sleepStart: _sleepStart));
        break;
      case WatchState.Help:
        setState(() {
          _sleepStart = DateTime.now();
          _state = WatchState.Sleep;
        });
        getSleepProgressDao().insertSleepProgress(newSleepProgress(
            state: _state, helpStart: _helpStart, sleepStart: _sleepStart));
        break;
      case WatchState.Sleep:
        final candidate =
            newSleepHistory(helpStart: _helpStart, sleepStart: _sleepStart);
        if (candidate.helpSeconds > 0 || candidate.sleepSeconds > 0) {
          getSleepHistoryDao().insertSleepHistory(candidate);
          updateLastSleepHistory(candidate);
          setState(() {
            _lastHistory = candidate;
          });
        }
        _clearSleepContext();
        break;
    }
  }

  void _clearSleepContext() {
    getSleepProgressDao().deleteAllSleepProgresses();
    setState(() {
      _helpStart = null;
      _sleepStart = null;
      _state = WatchState.Ready;
    });
  }

  void _debugAction(BuildContext context, Future<void> Function() act) async {
    if ((await promptDialog(
            context: context,
            title: "디버그",
            body: "디버그",
            yes: "네",
            no: "아니오")) ==
        true) {
      await act();
      setState(() {});
    }
  }

  Future<void> _clearDatabase() async {
    print("Clear all database!");
    _clearSleepContext();
    await clearDatabase();
  }
}
