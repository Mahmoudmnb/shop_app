import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.image,
    required this.username,
    required this.email,
  });
  final Image? image;
  final String username;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.93.w),
      child: Row(
        children: [
          const CircleAvatar(radius: 23, backgroundColor: Color(0xFFD9D9D9)),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 7.5.h),
              Text(
                email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11.sp,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
