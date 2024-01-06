import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shop_app/featurs/main_page/featurs/wishlist/bloc/wishlist_cubit.dart';

import '../../home/models/product_model.dart';
import '../../products_view/cubits/product_screen/cubit.dart';
import '../../products_view/screens/product_screen.dart';
import '../../shopping_bag/widgets/custom_app_bar.dart';
import '../widgets/border_card.dart';
import '../widgets/wishlist_switcher.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(title: 'Wishlist'),
            Padding(
              padding: EdgeInsets.only(right: 25.w, left: 25.w, top: 7.h),
              child: const Divider(color: Color(0xFFC6C6C6), height: 0),
            ),
            SizedBox(height: 16.h),
            const WishlistSwitcher(text1: 'Borders', text2: 'All items'),
            context.read<WishlistCubit>().kindOfOrder == "Borders"
                ? Expanded(
                    child: SizedBox(
                      width: 340,
                      child: ListView.separated(
                          itemCount: 11,
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: 15.h),
                          itemBuilder: (BuildContext context, int index) =>
                              index == 0
                                  ? SizedBox(height: 15.h)
                                  : const BorderCard()),
                    ),
                  )
                : Expanded(
                    //* this widget have to be exit for (AnimationConfiguration)
                    child: AnimationLimiter(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 10,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .7.h,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {

                          
                          ProductModel product =
                              ProductModel.fromMap(categoryProducts[index]);
                          //* this is the animation
                          return AnimationConfiguration.staggeredGrid(
                            duration: const Duration(milliseconds: 500),
                            position: index,
                            columnCount: 2,
                            child: ScaleAnimation(
                              curve: Curves.fastEaseInToSlowEaseOut,
                              // curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 500),
                              child: GestureDetector(
                                onTap: () {
                                  ProductCubit productCubit =
                                      BlocProvider.of<ProductCubit>(context);
                                  productCubit.widthOfPrice = 145;
                                  productCubit.hidden = false;
                                  productCubit
                                      .getReviws(product.id)
                                      .then((value) {
                                    productCubit
                                        .getSimilarProducts(product)
                                        .then((value) {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                          categoryName: categoryName,
                                          fromPage: 'CategoryProducts',
                                          searchCubit: cubit,
                                          searchWord: searchController.text,
                                          product: product,
                                          cubit: BlocProvider.of<ProductCubit>(
                                              context),
                                        ),
                                      ));
                                    });
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 4),
                                                color: Colors.black
                                                    .withOpacity(.25),
                                                blurRadius: 2)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        alignment: const Alignment(.80, -.89),
                                        children: [
                                          Image.asset(
                                            product.imgUrl.split('|')[0].trim(),
                                            fit: BoxFit.cover,
                                            height: 206.h,
                                            width: 141.w,
                                          ),
                                          Positioned(
                                            right: 2.w,
                                            child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      // if (searchController.text ==
                                                      //     '') {
                                                      //   cubit
                                                      //       .setFavorateProduct(
                                                      //           product.id,
                                                      //           !product.isFavorite)
                                                      //       .then((value) {
                                                      //     cubit.searchInCategory(
                                                      //         null, categoryName);
                                                      //   });
                                                      // } else {
                                                      //   cubit
                                                      //       .setFavorateProduct(
                                                      //           product.id,
                                                      //           !product.isFavorite)
                                                      //       .then((value) {
                                                      //     cubit.searchInCategory(
                                                      //         searchController.text,
                                                      //         categoryName);
                                                      //   });
                                                      // }
                                                    },
                                                    child: Container(
                                                        height: 33.h,
                                                        width: 33.h,
                                                        alignment: Alignment
                                                            .center,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: product
                                                                .isFavorite
                                                            ? const Icon(
                                                                Icons.favorite,
                                                                color: Color(
                                                                    0xffFF6E6E),
                                                              )
                                                            : const Icon(
                                                                Icons.favorite,
                                                                color: Color(
                                                                    0xffD8D8D8),
                                                              )))),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    SizedBox(
                                      height: 25.h,
                                      width: 141.w,
                                      child: Row(
                                        children: [
                                          Text(
                                            product.makerCompany,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'Tenor Sans',
                                                color: const Color(0xff393939)),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${product.price} \$",
                                            style: TextStyle(
                                                fontFamily: 'Tenor Sans',
                                                color: const Color(0xFFD57676),
                                                fontSize: 10.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 17.h,
                                      width: 141.w,
                                      child: Text(
                                        product.name,
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: const Color(0xFF828282),
                                            fontFamily: 'Tenor Sans'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            SizedBox(height: 15.h)
          ],
        ),
      ),
    );
  }
}
