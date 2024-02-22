import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shop_app/injection.dart';

import '../../../data_source/data_source.dart';
import '../../home/models/product_model.dart';
import '../../products_view/cubits/product_screen/cubit.dart';
import '../../products_view/screens/product_view_secreens.dart';
import '../../search/cubit/sreach_cubit.dart';
import 'wishlist_screen.dart';

class BorderProductView extends StatelessWidget {
  final List<Map<String, dynamic>> borderProducts;
  final String borderName;
  const BorderProductView(
      {super.key, required this.borderName, required this.borderProducts});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        sl.get<DataSource>().getBorders().then((borders) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => WishListScreen(borders: borders)));
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 75.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<Map<String, dynamic>> borders =
                            await sl.get<DataSource>().getBorders();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      WishListScreen(borders: borders)));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 36.w,
                        width: 36.w,
                        padding: EdgeInsets.only(left: 4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0.1, 2),
                                  blurRadius: .4,
                                  color: Colors.black.withOpacity(.25))
                            ]),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$borderName Border',
                          style: TextStyle(fontSize: 25.sp),
                        ),
                        Text(
                          "${borderProducts.length} items ",
                          style: TextStyle(
                              color: const Color(0xFF979797),
                              fontSize: 16.sp,
                              fontFamily: 'Tenor Sans'),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: AnimationLimiter(
                  child: GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    itemCount: borderProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .7.h,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      ProductModel product =
                          ProductModel.fromMap(borderProducts[index]);
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
                              productCubit.getReviws(product.id).then((value) {
                                productCubit
                                    .getSimilarProducts(product)
                                    .then((value) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      fromPageTitle: '$borderName Border',
                                      categoryName: borderName,
                                      fromPage: 'BorderProducts',
                                      searchCubit:
                                          BlocProvider.of<SearchCubit>(context),
                                      searchWord: '',
                                      product: product,
                                      cubit: productCubit,
                                    ),
                                  ));
                                });
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 4),
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 2)
                                  ], borderRadius: BorderRadius.circular(10)),
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
                                                onTap: () {},
                                                child: Container(
                                                    height: 33.h,
                                                    width: 33.h,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: product.isFavorite
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
            ],
          ),
        ),
      ),
    );
  }
}
