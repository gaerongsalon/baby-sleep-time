import 'package:baby_sleep_time/utils/print_readable_duration.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../components/date_header.dart';
import '../../components/loading_page.dart';
import '../../components/prompt_dialog.dart';
import '../../components/sleep_time_log.dart';
import '../../components/sleep_time_log_item.dart';
import '../../components/text_divider.dart';
import '../../models/sleep_history.dart';
import '../../services/store/store.dart';
import '../../utils/date_converter.dart';

class TableTabPage extends StatefulWidget {
  const TableTabPage({Key key}) : super(key: key);

  @override
  _TableTabPageState createState() => _TableTabPageState();
}

class _TableTabPageState extends State<TableTabPage> {
  bool _loading = false;
  int _yyyyMMdd = asyyyyMMdd(DateTime.now());
  List<SleepHistory> _histories = [];

  @override
  void initState() {
    super.initState();
    _updateDate(_yyyyMMdd);
  }

  void _updateDate(int yyyyMMdd) async {
    final dao = getSleepHistoryDao();
    final histories = await dao.findSleepHistoriesByDate(yyyyMMdd);
    setState(() {
      _loading = true;
      _yyyyMMdd = yyyyMMdd;
      _histories = histories.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading) {
      return LoadingPage();
    }
    return _buildListView();
  }

  Widget _buildListView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: Column(
        children: [
          _buildDateSelector(),
          _histories.length == 0
              ? _buildEmpty()
              : Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextDivider(
        text: "아직 기록이 없습니다.",
      ),
    );
  }

  Widget _buildDateSelector() {
    return DateHeader(
      yyyyMMdd: _yyyyMMdd,
      onDateChanged: _updateDate,
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(1.3),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.0),
          },
          children: [
            TableRow(children: [
              TableCell(child: Text("")),
              _IconCell(
                  icon: FluentSystemIcons.ic_fluent_people_filled, label: "도움"),
              _IconCell(
                  icon: FluentSystemIcons.ic_fluent_sleep_filled, label: "수면"),
            ])
          ]..addAll(_histories.map((item) => TableRow(children: [
                _TextCell(
                  text: DateFormat.jm().format(item.start),
                  fontSize: 15.0,
                  onLongPress: () => _deleteItem(item),
                ),
                _TextCell(
                  text: printReadableDuration(item.helpDuration),
                  fontWeight: FontWeight.bold,
                ),
                _TextCell(
                  text: printReadableDuration(item.sleepDuration),
                  fontWeight: FontWeight.bold,
                ),
              ]))),
        ),
      ),
    );
  }

  void _deleteItem(SleepHistory history) async {
    if ((await promptDialog(
            context: context,
            title: "삭제할까요?",
            body: "선택한 항목을 삭제합니다.",
            yes: "삭제",
            no: "취소")) ==
        true) {
      getSleepHistoryDao().deleteSleepHistory([history]).then((_) {
        setState(() {
          _histories.remove(history);
        });
      });
    }
  }
}

class _IconCell extends StatelessWidget {
  const _IconCell({
    Key key,
    @required this.icon,
    @required this.label,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Column(
        children: [Icon(icon), Text(label)],
      ),
    ));
  }
}

class _TextCell extends StatelessWidget {
  const _TextCell({
    Key key,
    @required this.text,
    this.onLongPress,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final String text;
  final GestureLongPressCallback onLongPress;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 28.0),
            child: Text(text,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1
                    .copyWith(fontSize: fontSize, fontWeight: fontWeight)),
          ),
        ));
  }
}
