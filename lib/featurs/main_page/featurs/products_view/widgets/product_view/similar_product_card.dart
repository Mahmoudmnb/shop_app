import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/models/product_model.dart';
import '../../../search/cubit/sreach_cubit.dart';
import '../../cubits/product_screen/cubit.dart';
import '../../screens/product_view_secreens.dart';
import '../product_view_widgets.dart';

class SimilarProductsCard extends StatelessWidget {
  final ProductModel product;
  final String searchWord;
  final String categoryName;
  final SearchCubit searchCubit;
  final ProductCubit cubit;
  final String fromPage;

  const SimilarProductsCard(
      {super.key,
      required this.fromPage,
      required this.cubit,
      required this.product,
      required this.searchCubit,
      required this.categoryName,
      required this.searchWord});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393.w,
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 19.5.w),
                child: Text(
                  'Similar Items',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: 'Tenor Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.06,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 19.5.w),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF9B9B9B),
                  ),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.05,
                    ),
                  ),
                  onPressed: () async {
                    log('See All');
                    cubit.getProductById(product.id).then((product) {
                      cubit
                          .getSimilarProducts(ProductModel.fromMap(product))
                          .then((value) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SimilarItemsScreen(
                              fromPage: fromPage,
                              categoryName: categoryName,
                              searchCubit: searchCubit,
                              product: ProductModel.fromMap(product),
                              searchWord: searchWord,
                              similarProducts: cubit.similarProducts,
                              productCubit: cubit,
                            ),
                          ),
                        );
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.5.h),
          Row(
            children: [
              SizedBox(
                width: 355.w,
                //* I put this height to show all simlair items
                //* __(heightCard + heightAddToCartButton)__
                height: 190.h + 100.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  shrinkWrap: true,
                  itemCount: cubit.similarProducts.length < 6
                      ? cubit.similarProducts.length
                      : 6,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 10.w),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, int index) {
                    ProductModel product =
                        ProductModel.fromMap(cubit.similarProducts[index]);
                    return CustomCard(
                      width: 136.5.w,
                      height: 174.5.h,
                      product: product,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
