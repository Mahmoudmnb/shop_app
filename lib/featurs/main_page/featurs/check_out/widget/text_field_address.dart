import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldAddress extends StatelessWidget {
  const TextFieldAddress({
    super.key,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.countryCode,
  });
  final List<Map<String, dynamic>>? countryCode;
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      height: 50.h,
      child: TextFormField(
        readOnly: title == 'longitude code' ||
            title == 'latitude code' ||
            title == 'City' ||
            title == 'Country' ||
            title == 'Address',
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
            prefix: title == 'Phone Number'
                ? Text(countryCode![0]['dial_code'] + '  ')
                : null,
            label:
                Text(title, style: const TextStyle(color: Color(0xFF0C0C0C))),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF7E7E7E))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF7E7E7E))),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
