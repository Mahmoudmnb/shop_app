// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';

import '../cubits/item_product_cubit/item_product_cubit.dart';

class ProductItem extends StatelessWidget {
  ProductItem(
      {super.key,
      required this.title,
      required this.brand,
      required this.color,
      required this.size,
      required this.price,
      required this.amountOfProduct,
      required this.id,
      required this.imgUrl});
  final int id;
  final String title;
  final String brand;
  final Color color;
  final String size;
  final double price;
  int amountOfProduct;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 7.6335.w),
      width: 393.w, //- 2 * 7.6335.w,
      height: 117.h,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE3E3E3),
            offset: Offset(1, 3),
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage(imgUrl),
            fit: BoxFit.cover,
            width: 81.w,
            height: 852.h,
          ),
          SizedBox(width: 20.w),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 17.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160.w,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.06,
                      letterSpacing: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Brand: $brand',
                  style: TextStyle(
                    color: const Color(0xFF9B9B9B),
                    fontSize: 13.sp,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      const TextSpan(text: 'Color:  '),
                      WidgetSpan(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.5.h),
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w / 2)),
                          ),
                        ),
                      ),
                      //* I know this is a failed solution, but it's esay to do  ^_^ :)
                      TextSpan(
                        text: '  |',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      TextSpan(text: '  Size:  $size'),
                    ],
                  ),
                  style: TextStyle(
                    color: const Color(0xFF9B9B9B),
                    fontSize: 12.sp,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 17.h, top: 17.h, right: 11.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$price\$',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  width: 57.w,
                  height: 25.5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read<ItemProductCubit>()
                              .removeAmount(id, amountOfProduct);
                          context.read<AddToCartCubit>().getAddToCartProducts();
                        },
                        child: Icon(Icons.remove, size: 14.sp),
                      ),
                      BlocBuilder<ItemProductCubit, ItemProductState>(
                        builder: (context, state) {
                          if (state is ItemProductChanged) {
                            if (state.product['id'] == id) {
                              amountOfProduct = state.product['quantity']!;
                            }
                          }
                          return Text(
                            amountOfProduct.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<ItemProductCubit>()
                              .addAmount(id, amountOfProduct);
                          context.read<AddToCartCubit>().getAddToCartProducts();
                        },
                        child: Icon(Icons.add, size: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
