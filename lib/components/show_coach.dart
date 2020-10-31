import 'dart:async';

import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';

Future<void> showCoach(
    {@required GlobalKey globalKey,
    @required String text,
    int startDelayMillis = 500,
    bool circle = true,
    Duration duration = const Duration(seconds: 5),
    Rect Function(Rect) rectModifier}) async {
  await Future.delayed(Duration(milliseconds: startDelayMillis));

  final coachMark = CoachMark();
  RenderBox target = globalKey.currentContext.findRenderObject();
  Rect markRect = target.localToGlobal(Offset.zero) & target.size;
  if (circle) {
    markRect = Rect.fromCircle(
        center: markRect.center, radius: markRect.longestSide * 0.7);
  }
  if (rectModifier != null) {
    markRect = rectModifier(markRect);
  }

  var completer = Completer();
  coachMark.show(
      targetContext: globalKey.currentContext,
      markRect: markRect,
      markShape: circle ? BoxShape.circle : BoxShape.rectangle,
      children: [
        Positioned(
            top: markRect.bottom + 40.0,
            left: 0,
            right: 0,
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                )))
      ],
      duration: duration,
      onClose: () => completer.complete());
  return completer.future;
}
