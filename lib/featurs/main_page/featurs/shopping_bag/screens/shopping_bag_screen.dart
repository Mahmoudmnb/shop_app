import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../check_out/cubit/check_out_cubit.dart';
import '../../check_out/screens/first_step.dart';
import '../cubits/products_cubit/products_cubit.dart';
import '../widgets/custom_app_bar.dart';
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
          body: Column(
            children: [
              const CustomAppBar(),
              Padding(
                padding: EdgeInsets.only(right: 25.w, left: 25.w, top: 7.h),
                child: const Divider(color: Color(0xFFC6C6C6), height: 0),
              ),
              context.watch<AddToCartCubit>().products.isEmpty
                  ? Expanded(
                      //! this padding to put the image and the text in the center
                      //! by looking at screen :)
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: const AssetImage(
                                  'assets/images/empty_cart.png'),
                              width: 150.w,
                              height: 150.w,
                            ),
                            SizedBox(height: 5.h),
                            Text('Your cart is empty',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'DM Sans',
                                    fontSize: 18.sp)),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
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
