import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/date_converter.dart';
import 'package:baby_sleep_time/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateHeader extends StatelessWidget {
  final int yyyyMMdd;
  final void Function(int yyyyMMdd) onDateChanged;

  DateHeader({Key key, @required this.onDateChanged, this.yyyyMMdd = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Center(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 32.0,
            onPressed: () {
              this.onDateChanged(addDaysToyyyyMMdd(this.yyyyMMdd, -1));
            },
          ),
          GestureDetector(
            child: Text(DateFormat.MMMd().format(fromyyyyMMdd(this.yyyyMMdd)),
                style: TextStyle(fontSize: 24, color: Constants.IndigoColor)),
            onTap: () {
              final firstHistory = getFirstSleepHistory();
              final lastHistory = getLastSleepHistory();
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: firstHistory?.start ?? DateTime.now(),
                  maxTime: lastHistory?.start ?? DateTime.now(),
                  onConfirm: (date) {
                this.onDateChanged(asyyyyMMdd(date));
              },
                  currentTime: fromyyyyMMdd(this.yyyyMMdd),
                  locale: LocaleType.ko);
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 32.0,
            onPressed: () {
              this.onDateChanged(addDaysToyyyyMMdd(this.yyyyMMdd, 1));
            },
          ),
        ],
      )),
    );
  }
}
