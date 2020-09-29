import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/theme_config.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '자장자장',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      initialRoute: '/',
      onGenerateRoute: this._routePage,
      home: SplashScreen(),
    );
  }

  MaterialPageRoute _routePage(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.name:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
