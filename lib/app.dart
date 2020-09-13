import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';

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
