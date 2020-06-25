import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/print_duration.dart';
import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  final int initialSeconds;
  final bool initialGoing;

  Stopwatch(
      {Key key, @required this.initialSeconds, @required this.initialGoing})
      : super(key: key);

  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  bool _timerGoing = false;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    _timerGoing = widget.initialGoing;
    if (_timerGoing) {
      _startFakeTimer();
    }
  }

  @override
  void didUpdateWidget(Stopwatch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seconds = widget.initialSeconds;
    if (_timerGoing && !widget.initialGoing) {
      _timerGoing = false;
    } else if (!_timerGoing && widget.initialGoing) {
      _timerGoing = true;
      _startFakeTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timerGoing = false;
  }

  Future _startFakeTimer() async {
    while (_timerGoing) {
      await Future.delayed(Duration(seconds: 1));
      if (_timerGoing) {
        setState(() {
          ++_seconds;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      printDuration(Duration(seconds: this._seconds)),
      style: TextStyle(fontSize: 64, color: Constants.IndigoColor),
    );
  }
}
