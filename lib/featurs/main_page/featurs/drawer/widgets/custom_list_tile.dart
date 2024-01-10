
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    this.isSelected,
    this.onTap,
    required this.icon,
    required this.title,
  });
  final bool? isSelected;
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        width: 393.w,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: isSelected ?? false
              ? const Color(0x60E8E8E8)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected ?? false ? Colors.black : const Color(0xFF818181),
            ),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ?? false
                    ? Colors.black
                    : const Color(0xFF818181),
                fontSize: 15.sp,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
                height: 1.4,
                letterSpacing: 0.64,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
