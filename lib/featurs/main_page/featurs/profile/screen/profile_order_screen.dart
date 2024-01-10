import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/screen/orders_screen.dart';

class ProfileOrderScreen extends StatelessWidget {
  const ProfileOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.7),
                            blurRadius: 0.5,
                            color: Colors.grey,
                          ),
                        ]),
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'My Orders',
                      style: TextStyle(fontSize: 25.sp),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            const Expanded(child: MyOrdersScreen())
          ],
        ),
      ),
    );
  }
}
