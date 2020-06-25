import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/print_duration.dart';
import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatelessWidget {
  final SleepHistory sleepHistory;
  final double topMargin;
  final double bottomMargin;

  const HistoryItem(
      {Key key,
      @required this.sleepHistory,
      this.topMargin = 80,
      this.bottomMargin = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
          child: TextDivider(text: DateFormat.jms().format(sleepHistory.start)),
        ),
        _HistoryLogLine(
            seconds: sleepHistory.helpSeconds, icon: Icons.child_care),
        _HistoryLogLine(
            seconds: sleepHistory.sleepSeconds,
            icon: Icons.airline_seat_individual_suite)
      ],
    );
  }
}

class _HistoryLogLine extends StatelessWidget {
  final int seconds;
  final IconData icon;

  const _HistoryLogLine({Key key, @required this.seconds, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            printDuration(Duration(seconds: this.seconds)),
            style: TextStyle(fontSize: 28, color: Constants.LightIndigoColor),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Icon(this.icon, size: 40.0, color: Constants.IndigoColor),
          ),
        ],
      ),
    );
  }
}
