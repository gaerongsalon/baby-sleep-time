import '../../services/messages.dart';
import '../../services/store/tip_state.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/store/store.dart';
import '../../theme/theme_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    await currentTheme.loadTheme();
    await TipState.instance.load();
    await prepareStore();
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pushReplacementNamed(Constants.HomeScreenName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/avatar.png",
                  width: 240,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text(kText_AppTitle,
                      style: TextStyle(
                          decoration: TextDecoration.none, fontSize: 24.0)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
