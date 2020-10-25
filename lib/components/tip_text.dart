import 'package:flutter/material.dart';

class TipText extends StatelessWidget {
  const TipText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tipBackgroundColor = theme.buttonColor.withAlpha(40);
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.all(8.0),
      color: tipBackgroundColor,
      child: Text(this.text,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
    );
  }
}
