import 'package:baby_sleep_time/constants.dart';
import 'package:baby_sleep_time/date_converter.dart';
import 'package:baby_sleep_time/history_item.dart';
import 'package:baby_sleep_time/sleep_history.dart';
import 'package:baby_sleep_time/store.dart';
import 'package:baby_sleep_time/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    getSleepHistoryDao().findSleepHistoriesByDate(_yyyyMMdd).then((result) {
      setState(() {
        _loading = true;
        _histories = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading) {
      return Container(color: Constants.BeigeColor);
    }
    return Container(
      color: Constants.BeigeColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        itemBuilder: (context, listIndex) {
          if (listIndex == 0) {
            if (_histories.length == 0) {
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
            return _buildHeader();
          }
          return _buildItem(listIndex);
        },
        itemCount: _histories.length + 1,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Center(
          child: Text(DateFormat.MMMd().format(fromyyyyMMdd(_yyyyMMdd)),
              style: TextStyle(fontSize: 24, color: Constants.IndigoColor))),
    );
  }

  Widget _buildItem(int listIndex) {
    return InkWell(
      onLongPress: () => _deleteItem(_histories[listIndex - 1], listIndex - 1),
      child: HistoryItem(
        sleepHistory: _histories[listIndex - 1],
        topMargin: 24,
        bottomMargin: 12,
      ),
    );
  }

  void _deleteItem(SleepHistory history, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete item?"),
          content: Text("This will delete it permanently."),
          actions: <Widget>[
            FlatButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
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
              child:
                  Text("Close", style: TextStyle(color: Constants.IndigoColor)),
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
