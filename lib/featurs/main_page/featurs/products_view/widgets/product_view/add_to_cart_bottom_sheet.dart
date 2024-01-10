import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/main_page/cubit/main_page_cubit.dart';

import '../../../home/models/product_model.dart';
import '../../cubits/product_screen/cubit.dart';
import 'product_view_custom_button.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final bool isDiscount;
  final ProductModel product;
  final bool hidden;
  final double widthOfPrice;
  const AddToCartBottomSheet({
    super.key,
    required this.isDiscount,
    required this.product,
    required this.hidden,
    required this.widthOfPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15, top: 8, right: 20, left: 20),
      color: Colors.white,
      width: 393.w,
      height: 85.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(children: [
            AnimatedContainer(
                width: widthOfPrice,
                duration: const Duration(milliseconds: 200)),
            hidden
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                                color: const Color(0xFFAAAAAA),
                                fontSize: 10.sp,
                                fontFamily: 'DM Mono',
                                letterSpacing: 1.0,
                                wordSpacing: 1),
                          ),
                          SizedBox(height: 8.5.h),
                          Text(
                            isDiscount
                                ? '${(1 - product.disCount / 100) * product.price} \$'
                                : product.price.toString(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      !isDiscount
                          ? const SizedBox()
                          : Text(
                              '\$${product.price}',
                              style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    const Color(0xFF000000).withOpacity(.57),
                                color: const Color(0xFFD47676),
                                fontSize: 12.sp,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                    ],
                  ),
          ]),
          SizedBox(width: hidden ? 0 : 11.w),
          Expanded(
            child: ProductViewCustomButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: const AssetImage('assets/images/icon.png'),
                      width: 20.w,
                      height: 20.w),
                  SizedBox(width: 7.5.w),
                  Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
              onPressed: () {

                if (Constant.currentUser == null) {
                  context.read<MainPageCubit>().showRegisterMessage(context);
                } else {
                  context.read<ProductCubit>().addToCart(product);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.black,
                      content: Container(
                        width: 262.w,
                        height: 244.h,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Item added to cart',
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                  fontFamily: 'DM Sans'),
                            ),
                            SizedBox(height: 40.h),
                            Image.asset(
                              'assets/images/icon.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),

                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
