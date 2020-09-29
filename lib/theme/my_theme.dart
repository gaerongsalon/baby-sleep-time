import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme with ChangeNotifier {
  static bool _dark = true;

  ThemeMode currentTheme() {
    return _dark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark {
    return _dark;
  }

  void switchTheme() {
    _dark = !_dark;
    SharedPreferences.getInstance().then((pref) {
      pref.setBool("darkMode", _dark);
    });
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences.getInstance().then((pref) {
      _dark = pref.getBool("darkMode") ?? false;
      notifyListeners();
    });
  }
}
