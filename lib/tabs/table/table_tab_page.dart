import '../../services/messages.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/date_header.dart';
import '../../components/loading_page.dart';
import '../../components/prompt_dialog.dart';
import '../../components/text_divider.dart';
import '../../components/tip_text.dart';
import '../../models/sleep_history.dart';
import '../../services/store/store.dart';
import '../../services/store/tip_state.dart';
import '../../utils/date_converter.dart';
import '../../utils/print_readable_duration.dart';

class TableTabPage extends StatefulWidget {
  const TableTabPage({Key key}) : super(key: key);

  @override
  _TableTabPageState createState() => _TableTabPageState();
}

class _TableTabPageState extends State<TableTabPage> {
  bool _loading = false;
  int _yyyyMMdd = asyyyyMMdd(DateTime.now());
  List<SleepHistory> _histories = [];

  final _tableGlobalKey = GlobalKey();

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
          !TipState.instance.isShown(TipState.tableKey)
              ? GestureDetector(
                  onTap: () => setState(
                      () => TipState.instance.markAsShown(TipState.tableKey)),
                  child: TipText(text: kText_TipTable))
              : Container(),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextDivider(
          text: kText_TableNoData,
        ),
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
          key: _tableGlobalKey,
          columnWidths: {
            0: FlexColumnWidth(1.3),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.0),
          },
          children: [
            TableRow(children: [
              TableCell(child: Text("")),
              _IconCell(
                  icon: FluentSystemIcons.ic_fluent_people_filled,
                  label: kText_ActionHelp),
              _IconCell(
                  icon: FluentSystemIcons.ic_fluent_sleep_filled,
                  label: kText_ActionSleep),
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
                  onLongPress: () => _deleteItem(item),
                ),
                _TextCell(
                  text: printReadableDuration(item.sleepDuration),
                  fontWeight: FontWeight.bold,
                  onLongPress: () => _deleteItem(item),
                ),
              ]))),
        ),
      ),
    );
  }

  void _deleteItem(SleepHistory history) async {
    if ((await promptDialog(
            context: context,
            title: kText_TableConfirmToDelete,
            body: kText_TableDeleteLabel,
            yes: kText_ActionDelete,
            no: kText_ActionCancel)) ==
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
