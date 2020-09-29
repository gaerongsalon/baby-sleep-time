import 'package:flutter/material.dart';

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
    return MaterialButton(
      onPressed: this.onPressed,
      child: Icon(
        this.icon,
        size: 75.0,
      ),
      elevation: 2.0,
      color: Theme.of(context).buttonColor,
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
