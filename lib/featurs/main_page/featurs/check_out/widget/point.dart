import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckOutPoint extends StatelessWidget {
  const CheckOutPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: 4,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          color: const Color(0xFFC8C7CC),
          borderRadius: BorderRadius.circular(4)),
    );
  }
}
