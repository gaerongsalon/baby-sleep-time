import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/date_converter.dart';
import 'package:baby_sleep_time/date_header.dart';
import 'package:baby_sleep_time/sleep_time_log.dart';
import 'package:baby_sleep_time/loading_page.dart';
import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/store.dart';
import 'package:baby_sleep_time/text_divider.dart';
import 'package:flutter/material.dart';

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
      color: Constants.BeigeColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        itemBuilder: (context, listIndex) {
          return listIndex == 0
              ? _histories.length == 0 ? _buildEmpty() : _buildHeader()
              : _buildItem(listIndex);
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

  Widget _buildItem(int listIndex) {
    return InkWell(
      onLongPress: () => _deleteItem(_histories[listIndex - 1], listIndex - 1),
      child: SleepTimeLog(
        startTime: _histories[listIndex - 1].start,
        helpSeconds: _histories[listIndex - 1].helpSeconds,
        sleepSeconds: _histories[listIndex - 1].sleepSeconds,
        topMargin: 24,
        bottomMargin: 12,
        showTime: true,
      ),
    );
  }

  void _deleteItem(SleepHistory history, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("삭제할까요?"),
          content: Text("선택한 항목을 삭제합니다."),
          actions: <Widget>[
            FlatButton(
              child: Text("삭제", style: TextStyle(color: Colors.red)),
              onPressed: () {
                getSleepHistoryDao().deleteSleepHistory([history]).then((_) {
                  setState(() {
                    _histories.removeAt(index);
                  });
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("취소", style: TextStyle(color: Constants.IndigoColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
