import 'package:baby_sleep_time/home_screen.dart';
import 'package:baby_sleep_time/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '자장자장',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
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
