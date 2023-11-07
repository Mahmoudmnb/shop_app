import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistBorder extends StatelessWidget {
  const WishlistBorder({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF494949),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image(
                image: const AssetImage('assets/images/11.jpg'),
                fit: BoxFit.cover,
                width: 60.w,
                height: 60.w,
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shirts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                const Text(
                  '24 item',
                  style: TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 10,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: ShapeDecoration(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.w / 2),
                  borderSide: const BorderSide(width: 1, color: Colors.white),
                ),
              ),
              child: Icon(Icons.add, size: 18.sp, color: Colors.white),
            ),
            SizedBox(width: 25.w),
          ],
        ),
      ),
    );
  }
}
