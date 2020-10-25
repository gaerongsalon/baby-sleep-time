import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class TipState {
  static const recordStartKey = "tipstate.recordstart";
  static const sleepStartButtonKey = "tipstate.sleepstart";
  static const wakeupButtonKey = "tipstate.wakeup";
  static const firstRecordKey = "tipstate.firstrecord";
  static const tableKey = "tipstate.table";
  static const chartKey = "tipstate.chart";

  static final _allKeys = [
    recordStartKey,
    sleepStartButtonKey,
    wakeupButtonKey,
    firstRecordKey,
    tableKey,
    chartKey,
  ];

  static final instance = TipState._internal();

  TipState._internal();

  final Map<String, bool> state = HashMap();

  Future<void> load() async {
    await SharedPreferences.getInstance().then((pref) {
      _allKeys.forEach((key) {
        state[key] = pref.getBool(key) ?? false;
      });
    });
  }

  bool isShown(String key) {
    return state[key] ?? false;
  }

  void markAsShown(String key) {
    state[key] = true;
    SharedPreferences.getInstance().then((pref) => pref.setBool(key, true));
  }

  void doIfPossible(String key, void Function(void Function()) callback) {
    if (isShown(key)) {
      return;
    }
    callback(() => markAsShown(key));
  }

  void resetAll() {
    state.clear();
    SharedPreferences.getInstance().then((pref) {
      _allKeys.forEach((key) {
        pref.remove(key);
      });
    });
  }
}
