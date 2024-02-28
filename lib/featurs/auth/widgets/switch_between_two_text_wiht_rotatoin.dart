import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constant.dart';

class SwitchBetweenTwoTextWithRotation extends StatelessWidget {
  final String firstText;
  final String secondText;
  final TextStyle textStyle;
  final bool isFirestText;
  const SwitchBetweenTwoTextWithRotation({
    Key? key,
    required this.isFirestText,
    required this.firstText,
    required this.secondText,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedOpacity(
        duration: Constant.duration,
        opacity: isFirestText ? 0 : 1,
        child: Center(
          child: AnimatedRotation(
            turns: !isFirestText ? 360 : -360 * pi,
            duration: Constant.duration,
            child: Text(
              firstText,
              style: textStyle,
            ),
          ),
        ),
      ),
      AnimatedOpacity(
        duration: Constant.duration,
        opacity: !isFirestText ? 0 : 1,
        child: Center(
          child: AnimatedRotation(
            turns: isFirestText ? 1 : -1,
            duration: Constant.duration,
            child: Text(
              secondText,
              style: textStyle,
            ),
          ),
        ),
      ),
    ]);
  }
}
