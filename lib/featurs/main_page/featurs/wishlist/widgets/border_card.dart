import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderCard extends StatelessWidget {
  const BorderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340.w,
      child: Column(
        children: [
          Container(
              height: 180.h,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(10)))),
          Padding(
              padding: EdgeInsets.only(left: 15.w, right: 25.w, top: 5.h),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shirts',
                    style: TextStyle(
                      color: Color(0xFF383838),
                      fontSize: 16,
                      fontFamily: 'Tenor Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    '24 Items',
                    style: TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 10,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 1,
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
