import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../utils/print_duration.dart';

const invalidTime = '--:--:--';

class SleepTimeLogItem extends StatelessWidget {
  final int seconds;
  final IconData icon;
  final DateTime time;

  const SleepTimeLogItem(
      {Key key, @required this.seconds, @required this.icon, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTime(),
          _buildSeconds(),
          _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildTime() {
    if (this.time == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 24.0),
      child: Text(
        DateFormat.jms().format(this.time),
        style: TextStyle(fontSize: 14, color: Constants.LightIndigoColor),
      ),
    );
  }

  Widget _buildSeconds() {
    return Text(
      seconds < 0
          ? invalidTime
          : printDuration(Duration(seconds: this.seconds)),
      style: TextStyle(fontSize: 28, color: Constants.LightIndigoColor),
    );
  }

  Widget _buildIcon() {
    return Padding(
      padding: this.time != null
          ? const EdgeInsets.only(left: 32.0)
          : const EdgeInsets.only(left: 48.0),
      child: Icon(this.icon, size: 40.0, color: Constants.IndigoColor),
    );
  }
}
