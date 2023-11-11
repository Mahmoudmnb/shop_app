import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../check_out/cubit/check_out_cubit.dart';
import '../../check_out/screens/first_step.dart';
import '../widgets/shopping_bag_body.dart';
import '../widgets/custom_button.dart';

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
                      context
                          .read<CheckOutCubit>()
                          .getLocations()
                          .then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstStep(
                            locations: value,
                          ),
                        ));
                      });
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
