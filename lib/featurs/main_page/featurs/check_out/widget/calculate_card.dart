import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculateCard extends StatelessWidget {
  const CalculateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: const Offset(0, -5),
            blurRadius: 11,
            color: Colors.black.withOpacity(.04))
      ]),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(
                width: 40.w,
              ),
              const Text(
                "Product Price",
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              const Text('\$100'),
              SizedBox(
                width: 40.w,
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFFE8E8E8),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(
                width: 40.w,
              ),
              const Text(
                "Shopping",
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              const Text('\$10'),
              SizedBox(
                width: 40.w,
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFFE8E8E8),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(
                width: 40.w,
              ),
              const Text(
                "Subtotal",
                style: TextStyle(fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              const Text('\$110'),
              SizedBox(
                width: 40.w,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
