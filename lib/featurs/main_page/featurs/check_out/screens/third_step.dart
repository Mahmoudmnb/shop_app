import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/main_page.dart';

import '../widget/point.dart';

class CheckOutScreen3 extends StatelessWidget {
  const CheckOutScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
            (route) => false);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
          child: Column(children: [
            // Row(
            //   children: [
            //     GestureDetector(
            //         onTap: () {
            //           Navigator.of(context).pop();
            //         },
            //         child: Image(
            //           height: 40.w,
            //           width: 40.w,
            //           image: const AssetImage("assets/images/backicon.png"),
            //         )),
            //     SizedBox(width: 10.w),
            //     Text(
            //       "Check out",
            //       style: TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
            //     )
            //   ],
            // ),
            SizedBox(height: 40.h),
            Row(
              children: [
                const Spacer(),
                Image(
                    height: 24.h,
                    image: const AssetImage('assets/images/location.png')),
                SizedBox(
                  width: 10.w,
                ),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                SizedBox(width: 10.w),
                Image(
                    height: 18.h,
                    image: const AssetImage('assets/images/card.png')),
                SizedBox(width: 10.w),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                const CheckOutPoint(),
                SizedBox(width: 10.w),
                Image(
                    height: 24.h,
                    image: const AssetImage('assets/images/check_out.png')),
                const Spacer(),
              ],
            ),
            SizedBox(height: 40.h),
            Text(
              "Order Completed",
              style: TextStyle(
                  fontFamily: "DM Sans",
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp),
            ),
            SizedBox(height: 40.h),
            Image(
                height: 120.h,
                image: const AssetImage('assets/images/check-circle.png')),
            SizedBox(height: 80.h),
            const Text(
              "Thank you for your purchase.",
              style: TextStyle(fontFamily: 'DM Sans', color: Color(0xFF3D3D3D)),
            ),
            const Text(
              "You can veiw your order in 'My Orders' section",
              style: TextStyle(fontFamily: 'DM Sans', color: Color(0xFF3D3D3D)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                    (route) => false);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24.h, horizontal: 25.w),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 13.h,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Continue Shopping",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
