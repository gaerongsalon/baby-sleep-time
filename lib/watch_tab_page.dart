import 'package:baby_sleep_time/circle_button.dart';
import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/history_item.dart';
import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/store.dart';
import 'package:baby_sleep_time/watch_state.dart';
import 'package:baby_sleep_time/stopwatch.dart';
import 'package:flutter/material.dart';

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
    initFromDatabase();
  }

  void initFromDatabase() async {
    final lastHistory = await getSleepHistoryDao().findLastSleepHistory();
    if (lastHistory != null) {
      setState(() {
        _loading = true;
        _lastHistory = lastHistory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_loading) {
      return Container(color: Constants.BeigeColor);
    }
    return Container(
      color: Constants.BeigeColor,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Text(
              _state == WatchState.Ready
                  ? "시작해볼까요?"
                  : _state == WatchState.Help ? "할 수 있어요!" : "잘자요!",
              style: TextStyle(fontSize: 24, color: Constants.LightIndigoColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Stopwatch(
              initialSeconds: _state == WatchState.Ready
                  ? 0
                  : DateTime.now().difference(_helpStart).inSeconds,
              initialGoing: _state != WatchState.Ready,
            ),
          ),
          CircleButton(
            icon: _buildActionIcon(),
            onPressed: _changeState,
          ),
          _buildLastHistory(),
        ],
      )),
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
    return _lastHistory == null
        ? Container()
        : HistoryItem(sleepHistory: _lastHistory);
  }

  void _changeState() {
    switch (_state) {
      case WatchState.Ready:
        setState(() {
          _helpStart = DateTime.now();
          _state = WatchState.Help;
        });
        break;
      case WatchState.Help:
        setState(() {
          _sleepStart = DateTime.now();
          _state = WatchState.Sleep;
        });
        break;
      case WatchState.Sleep:
        final candidate =
            newSleepHistory(helpStart: _helpStart, sleepStart: _sleepStart);
        if (candidate.helpSeconds > 0 || candidate.sleepSeconds > 0) {
          getSleepHistoryDao().insertSleepHistory(candidate);
        }
        setState(() {
          if (candidate.helpSeconds > 0 || candidate.sleepSeconds > 0) {
            _lastHistory = candidate;
          }
          _helpStart = null;
          _sleepStart = null;
          _state = WatchState.Ready;
        });
        break;
    }
    setState(() {});
  }
}
