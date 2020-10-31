import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class TipState {
  static const recordStartKey = "tip.state.recordstart";
  static const sleepStartButtonKey = "tip.state.sleepstart";
  static const wakeupButtonKey = "tip.state.wakeup";
  static const firstRecordKey = "tip.state.firstrecord";
  static const tableKey = "tip.state.table";
  static const chartKey = "tip.state.chart";

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
