import 'package:flutter/material.dart';

import '../../components/date_header.dart';
import '../../components/loading_page.dart';
import '../../components/prompt_dialog.dart';
import '../../components/sleep_time_log.dart';
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
      _histories = histories;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading) {
      return LoadingPage();
    }
    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        itemBuilder: (context, listIndex) {
          return listIndex == 0
              ? _histories.length == 0 ? _buildEmpty() : _buildHeader()
              : _buildItem(listIndex - 1);
        },
        itemCount: _histories.length + 1,
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        _buildHeader(),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextDivider(
            text: "아직 기록이 없습니다.",
          ),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return DateHeader(
      yyyyMMdd: _yyyyMMdd,
      onDateChanged: _updateDate,
    );
  }

  Widget _buildItem(int index) {
    return InkWell(
      onLongPress: () => _deleteItem(_histories[index], index),
      child: SleepTimeLog(
        startTime: _histories[index].start,
        helpSeconds: _histories[index].helpSeconds,
        sleepSeconds: _histories[index].sleepSeconds,
        topMargin: 24,
        bottomMargin: 12,
        showTime: true,
      ),
    );
  }

  void _deleteItem(SleepHistory history, int index) async {
    if ((await promptDialog(
            context: context,
            title: "삭제할까요?",
            body: "선택한 항목을 삭제합니다.",
            yes: "삭제",
            no: "취소")) ==
        true) {
      getSleepHistoryDao().deleteSleepHistory([history]).then((_) {
        setState(() {
          _histories.removeAt(index);
        });
      });
    }
  }
}
