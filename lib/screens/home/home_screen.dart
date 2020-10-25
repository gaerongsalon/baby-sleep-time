import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../tabs/chart/chart_tab_page.dart';
import '../../tabs/table/table_tab_page.dart';
import '../../tabs/watch/watch_tab_page.dart';
import '../../theme/theme_config.dart';

class HomeScreen extends StatefulWidget {
  static const name = Constants.HomeScreenName;

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  final _tabs = <Widget>[
    WatchTabPage(),
    TableTabPage(),
    ChartTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _tabs[_tabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
        currentIndex: _tabIndex,
        items: [
          const BottomNavigationBarItem(
            title: Text("기록"),
            icon: const Icon(FluentSystemIcons.ic_fluent_clock_filled),
          ),
          const BottomNavigationBarItem(
            title: Text("일지"),
            icon: const Icon(FluentSystemIcons.ic_fluent_clipboard_text_filled),
          ),
          const BottomNavigationBarItem(
            title: Text("통계"),
            icon: const Icon(FluentSystemIcons.ic_fluent_poll_filled),
          ),
        ],
      ),
      floatingActionButton: Column(
        children: [
          SizedBox(height: 18),
          FloatingActionButton(
            mini: true,
            child: Icon(currentTheme.isDark
                ? FluentSystemIcons.ic_fluent_weather_moon_regular
                : FluentSystemIcons.ic_fluent_weather_sunny_regular),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).textTheme.bodyText1.color,
            onPressed: () {
              currentTheme.switchTheme();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
