import 'package:baby_sleep_time/constants.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.BeigeColor,
      // child: Center(
      //   child: Image.asset(
      //     "assets/images/avatar.png",
      //     width: 60,
      //   ),
      // ),
    );
  }
}
