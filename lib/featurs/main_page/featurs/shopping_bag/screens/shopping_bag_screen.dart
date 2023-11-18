import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/shopping_bag/widgets/custom_app_bar.dart';

import '../../check_out/cubit/check_out_cubit.dart';
import '../../check_out/screens/first_step.dart';
import '../cubits/products_cubit/products_cubit.dart';
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

          body: Column(
            children: [
              const CustomAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: const Divider(color: Color(0xFFC6C6C6)),
              ),
              context.watch<AddToCartCubit>().products.isEmpty
                  ? const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Your cart is empty'),
                        ],
                      ),
                    )
                  : Expanded(
                      // height: 852.h,
                      // width: 393.w,
                      child: Stack(
                        children: [
                          const ShoppingBagBody(),
                          Positioned(
                            bottom: 0,
                            child: CustomButton(
                              title: 'Proceed to checkout',
                              onPressed: () {
                                // log(BlocProvider.of<AddToCartCubit>(context)
                                //     .products
                                //     .length
                                //     .toString());
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
            ],
          ),
        ),
      ),
    );
  }
}
