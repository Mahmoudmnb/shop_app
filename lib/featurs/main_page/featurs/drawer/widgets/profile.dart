import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';

class Profile extends StatelessWidget {
  final FileImage? image;
  final String username;
  final String email;
  const Profile({
    super.key,
    required this.image,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.93.w),
      child: Column(
        children: [
          Constant.currentUser != null
              ? Container(
                  padding: const EdgeInsets.all(35),
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: image == null
                      ? Text(
                          Constant.getLetterName(Constant.currentUser!.name),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        )
                      : null)
              : const SizedBox.shrink(),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                username,
                style: TextStyle(
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
