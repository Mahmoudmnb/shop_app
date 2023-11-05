import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../check_out/screens/first_step.dart';

import '../widgets/custom_button.dart';
import '../widgets/shopping_bag_body.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, _) => Scaffold(
          // backgroundColor: Colors.white,
          body: SizedBox(
            height: 852.h,
            width: 393.w,
            child: Stack(
              children: [
                const ShoppingBagBody(),
                Positioned(
                  bottom: 0,
                  child: CustomButton(
                    title: 'Proceed to checkout',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CheckOutScreen1(),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
