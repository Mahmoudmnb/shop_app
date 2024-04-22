import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final String fromPageTitle;
  const SimilarProductsCard(
      {super.key,
      required this.fromPage,
      required this.fromPageTitle,
      required this.cubit,
      required this.product,
      required this.searchCubit,
      required this.categoryName,
      required this.searchWord});

  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().getSimilarProducts(product);
    return Container(
      width: 393.w,
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Text(
                  'Similar Items',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: 'Tenor Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.06,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 19.5.w),
                child: cubit.similarProducts.isEmpty
                    //* this height to equal SizedBox's height with TextButton's height :)
                    ? SizedBox(height: 50.h)
                    : TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9B9B9B),
                        ),
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.05,
                          ),
                        ),
                        onPressed: () async {
                          cubit.getProductById(product.id).then((product) {
                            cubit
                                .getSimilarProducts(
                                    ProductModel.fromMap(product))
                                .then((value) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SimilarItemsScreen(
                                    fromPageTitle: fromPageTitle,
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
                width: 393.w,
                //* I put this height to show all simlair items
                //* (heightCard + heightAddToCartButton)
                height: 190.h + 100.h,
                child: cubit.similarProducts.isEmpty
                    ? Padding(
                        //* I do this way to put the text in the center of page
                        //* by looking to the UI not the code (the code is not center :) )
                        padding: EdgeInsets.only(bottom: 50.h),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: const AssetImage(
                                      'assets/images/nothing_found.png'),
                                  width: 80.h),
                              SizedBox(height: 15.h),
                              Text(
                                'There is no similar items',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: 'Tenor Sans',
                                  height: 1.06,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(left: 23.w, right: 15.w),
                        shrinkWrap: true,
                        itemCount: cubit.similarProducts.length < 6
                            ? cubit.similarProducts.length
                            : 6,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(width: 10.w),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, int index) {
                          ProductModel product = ProductModel.fromMap(
                              cubit.similarProducts[index]);
                          //! I make edit this widget
                          //! to can similar_card click on it and go to his product_view
                          //! and you have to fix it
                          //! vvvvvvvvvvvvvvvvvv Here vvvvvvvvvvvvvvvvvvvvvvvv
                          return GestureDetector(
                            onTap: () {
                              log(product.name);
                              // ProductCubit productCubit =
                              //     BlocProvider.of<ProductCubit>(context);
                              // productCubit.widthOfPrice = 145;
                              // productCubit.hidden = false;
                              // productCubit.getReviws(product.id).then((value) {
                              //   productCubit
                              //       .getSimilarProducts(product)
                              //       .then((value) {
                              //     Navigator.of(context)
                              //         .pushReplacement(MaterialPageRoute(
                              //       builder: (context) => ProductScreen(
                              //         categoryName: categoryName,
                              //         fromPage: 'seeAll',
                              //         searchCubit: cubit,
                              //         searchWord: searchController.text,
                              //         product: product,
                              //         fromPageTitle: categoryName,
                              //         cubit: BlocProvider.of<ProductCubit>(
                              //             context),
                              //       ),
                              //     ));
                              //   });
                              // });
                            },
                            child: CustomCard(
                              width: 136.5.w,
                              height: 174.5.h,
                              product: product,
                            ),
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
