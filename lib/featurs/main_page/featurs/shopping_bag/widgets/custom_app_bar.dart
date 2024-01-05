import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
      child: SizedBox(
        width: 393.w - 2 * 15.w,
        height: 59.h,
        child: Row(
          children: [
            IconButton(
              splashRadius: 28,
              icon: Image(
                image: const AssetImage('assets/images/Menu.png'),
                height: 24.w,
                width: 24.w,
              ),
              onPressed: () {},
            ),
            SizedBox(width: 3.9.w),
            IconButton(
              splashRadius: 28,
              icon: Icon(Icons.favorite_outline_sharp, size: 24.w),
              onPressed: () {},
            ),
            const Spacer(flex: 1),
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.50,
              ),
            ),
            const Spacer(flex: 2),
            IconButton(
              splashRadius: 28,
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              onPressed: () {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
