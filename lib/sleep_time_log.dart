import 'package:baby_sleep_time/sleep_time_log_item.dart';
import 'package:baby_sleep_time/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepTimeLog extends StatelessWidget {
  final DateTime startTime;
  final int helpSeconds;
  final int sleepSeconds;
  final double topMargin;
  final double bottomMargin;
  final bool showTime;

  const SleepTimeLog(
      {Key key,
      @required this.startTime,
      @required this.helpSeconds,
      @required this.sleepSeconds,
      this.topMargin = 80,
      this.bottomMargin = 16,
      this.showTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
          child: TextDivider(text: DateFormat.jms().format(startTime)),
        ),
        SleepTimeLogItem(
            seconds: helpSeconds,
            icon: Icons.child_care,
            time: showTime && helpSeconds > 0
                ? startTime.add(Duration(seconds: helpSeconds))
                : null),
        SleepTimeLogItem(
            seconds: sleepSeconds,
            icon: Icons.airline_seat_individual_suite,
            time: showTime && helpSeconds > 0 && sleepSeconds > 0
                ? startTime.add(Duration(seconds: helpSeconds + sleepSeconds))
                : null)
      ],
    );
  }
}
