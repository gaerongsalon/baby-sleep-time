import 'package:flutter/material.dart';

import '../constants.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  const CircleButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: this.onPressed,
      elevation: 2.0,
      fillColor: Constants.IndigoColor,
      child: Icon(
        this.icon,
        size: 35.0,
        color: Constants.BeigeColor,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
