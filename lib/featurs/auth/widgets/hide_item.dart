import 'package:flutter/material.dart';

import '../../../core/constant.dart';

class HideItem extends StatelessWidget {
  final Widget child;
  final double maxHight;
  final bool visabl;
  const HideItem({
    Key? key,
    required this.maxHight,
    required this.child,
    required this.visabl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Constant.duration,
      height: visabl ? maxHight : 0,
      child: AnimatedOpacity(
          duration: Constant.duration, opacity: visabl ? 1 : 0, child: child),
    );
  }
}
