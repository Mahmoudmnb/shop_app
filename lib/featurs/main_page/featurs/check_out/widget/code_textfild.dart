import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CodeTextFeild extends StatefulWidget {
  const CodeTextFeild({super.key});

  @override
  State<CodeTextFeild> createState() => _CodeTextFeildState();
}

class _CodeTextFeildState extends State<CodeTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Container(
                padding: EdgeInsets.only(top: 15.h),
                child: const Text(
                  'Validate',
                  style: TextStyle(color: Color(0xFF76D5AD)),
                ),
              ),
              hintText: 'Have a code? type it here...',
              hintStyle: const TextStyle(
                  color: Color(0xFFCBCDD8), fontFamily: 'DM Sans'))),
    );
  }
}
