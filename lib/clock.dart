import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/print_duration.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  final DateTime startTime;
  final bool initialGoing;

  Clock({Key key, @required this.startTime, @required this.initialGoing})
      : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  bool _timerGoing = false;
  DateTime _startTime = DateTime.now();
  Duration _currentSeconds = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _currentSeconds = DateTime.now().difference(_startTime);
    _timerGoing = widget.initialGoing;
    if (_timerGoing) {
      _startClock();
    }
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startTime = widget.startTime;
    _currentSeconds = DateTime.now().difference(_startTime);

    if (_timerGoing && !widget.initialGoing) {
      _timerGoing = false;
    } else if (!_timerGoing && widget.initialGoing) {
      _timerGoing = true;
      _startClock();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timerGoing = false;
  }

  Future _startClock() async {
    while (_timerGoing) {
      await Future.delayed(Duration(milliseconds: 333));
      if (_timerGoing) {
        setState(() {
          _currentSeconds = DateTime.now().difference(_startTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      printDuration(_currentSeconds),
      style: TextStyle(fontSize: 64, color: Constants.IndigoColor),
    );
  }
}
