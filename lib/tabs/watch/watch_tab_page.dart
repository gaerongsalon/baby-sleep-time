import 'dart:async';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

import '../../components/circle_button.dart';
import '../../components/loading_page.dart';
import '../../components/prompt_dialog.dart';
import '../../components/show_coach.dart';
import '../../components/sleep_time_log.dart';
import '../../models/sleep_history.dart';
import '../../models/sleep_progress.dart';
import '../../models/watch_state.dart';
import '../../services/debug/clear_database.dart';
import '../../services/debug/generate_test_data.dart';
import '../../services/store/store.dart';
import '../../services/store/tip_state.dart';
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

  final _actionGlobalKey = GlobalKey();
  final _cancelGlobalKey = GlobalKey();
  final _sleepLogGlobalKey = GlobalKey();

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

    _showStartButtonCoach();
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
              onLongPress: () => _debugAction(
                  context: context, text: "테스트 데이터 생성", act: generateTestData),
              child: _buildTitle()),
          GestureDetector(
              onLongPress: () => _debugAction(
                  context: context, text: "모든 데이터 삭제", act: _clearDatabase),
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
      key: _actionGlobalKey,
      icon: _buildActionIcon(),
      onPressed: _changeState,
    );
    final cancelButton = CircleButton(
      key: _cancelGlobalKey,
      icon: FluentSystemIcons.ic_fluent_dismiss_regular,
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
        ? FluentSystemIcons.ic_fluent_weather_moon_regular
        : _state == WatchState.Help
            ? FluentSystemIcons.ic_fluent_people_regular
            : FluentSystemIcons.ic_fluent_sleep_regular;
  }

  Widget _buildLastHistory() {
    return _state != WatchState.Ready
        ? SleepTimeLog(
            key: _sleepLogGlobalKey,
            startTime: _helpStart,
            helpSeconds: _sleepStart != null
                ? _sleepStart.difference(_helpStart).inSeconds
                : -1,
            sleepSeconds: -1,
          )
        : _lastHistory != null
            ? SleepTimeLog(
                key: _sleepLogGlobalKey,
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
        _showHelpButtonCoach();
        break;
      case WatchState.Help:
        setState(() {
          _sleepStart = DateTime.now();
          _state = WatchState.Sleep;
        });
        getSleepProgressDao().insertSleepProgress(newSleepProgress(
            state: _state, helpStart: _helpStart, sleepStart: _sleepStart));
        _showSleepButtonCoach();
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
        _showSleepLogCoach();
        break;
    }
  }

  void _showStartButtonCoach() {
    TipState.instance.doIfPossible(TipState.recordStartKey, (mark) async {
      await showCoach(
          globalKey: _actionGlobalKey,
          text: "아이가 스스로 잠들 수 있도록\n도와주는 수면 도움 시간을 기록해보세요");
      mark();
    });
  }

  void _showHelpButtonCoach() {
    TipState.instance.doIfPossible(TipState.sleepStartButtonKey, (mark) async {
      await showCoach(globalKey: _actionGlobalKey, text: "잠에 든다면 아이콘을 누르세요");
      await showCoach(
          globalKey: _cancelGlobalKey, text: "아이가 너무 힘들어 하면\n그만 둘 수 있어요");
      mark();
    });
  }

  void _showSleepButtonCoach() {
    TipState.instance.doIfPossible(TipState.wakeupButtonKey, (mark) async {
      await showCoach(globalKey: _actionGlobalKey, text: "잠에서 깨어났다면 아이콘을 누르세요");
      mark();
    });
  }

  void _showSleepLogCoach() {
    TipState.instance.doIfPossible(TipState.firstRecordKey, (mark) async {
      await showCoach(
          globalKey: _sleepLogGlobalKey,
          circle: false,
          rectModifier: (rect) {
            return Rect.fromLTWH(rect.left + 32.0, rect.top + 72.0,
                rect.width - 64.0, rect.height - 72.0);
          },
          text: "첫 수면기록이 완성되었어요");
      mark();
    });
  }

  void _clearSleepContext() {
    getSleepProgressDao().deleteAllSleepProgresses();
    setState(() {
      _helpStart = null;
      _sleepStart = null;
      _state = WatchState.Ready;
    });
  }

  void _debugAction(
      {BuildContext context, String text, Future<void> Function() act}) async {
    if (!_isInDebugMode) {
      return;
    }

    if ((await promptDialog(
            context: context, title: "디버그", body: text, yes: "네", no: "아니오")) ==
        true) {
      await act();
      setState(() {});
    }
  }

  Future<void> _clearDatabase() async {
    print("Clear all database!");
    _clearSleepContext();
    await clearDatabase();
    TipState.instance.resetAll();
  }

  bool get _isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
