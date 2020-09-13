import 'package:flutter/material.dart';

import '../constants.dart';

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 40.0, right: 20.0),
            child: Divider(
              color: Constants.IndigoColor,
              height: 36,
            )),
      ),
      Text(this.text, style: TextStyle(color: Constants.IndigoColor)),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 40.0),
            child: Divider(
              color: Constants.IndigoColor,
              height: 36,
            )),
      ),
    ]);
  }
}
