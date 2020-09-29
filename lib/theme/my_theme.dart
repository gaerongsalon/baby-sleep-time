import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _dark = false;

  ThemeMode currentTheme() {
    return _dark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark {
    return _dark;
  }

  void switchTheme() {
    _dark = !_dark;
    notifyListeners();
  }
}
