import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393.w,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          
          elevation: 0,
          foregroundColor: const Color(0xFFD47676),
          backgroundColor: const Color(0xAAECECEC),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: () {},
        child:  Text(
          'Log out',
          style: TextStyle(
            fontSize: 17.sp,
            color: const Color(0xFFD47676),
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            height: 1.08,
            letterSpacing: 0.72,
          ),
        ),
      ),
    );
  }
}
