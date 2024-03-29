import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/products_view/cubits/product_screen/cubit.dart';
import 'package:shop_app/injection.dart';

import '../../../home/models/product_model.dart';

class WishlistBorder extends StatelessWidget {
  final void Function()? onTap;
  final Map<String, dynamic> border;
  final ProductModel product;
  final int countOfProductInThisBorder;
  const WishlistBorder(
      {super.key,
      this.onTap,
      required this.border,
      required this.product,
      required this.countOfProductInThisBorder});

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
                image: AssetImage(product.imgUrl.split('|')[0]),
                fit: BoxFit.cover,
                width: 60.w,
                height: 60.w,
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  border['borderName'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  '$countOfProductInThisBorder items',
                  style: const TextStyle(
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
            border['id'] != 1
                ? GestureDetector(
                    onTap: () {
                      sl.get<DataSource>().deleteBorder(border['id']);
                      context.read<ProductCubit>().changeSelectedBorderName(
                          context.read<ProductCubit>().selectedBorder);
                    },
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.w / 2),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.white),
                        ),
                      ),
                      child:
                          Icon(Icons.remove, size: 18.sp, color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(width: 25.w),
          ],
        ),
      ),
    );
  }
}
