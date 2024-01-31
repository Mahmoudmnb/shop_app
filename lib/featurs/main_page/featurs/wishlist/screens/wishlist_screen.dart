import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/injection.dart';

import '../../home/models/product_model.dart';
import '../../products_view/cubits/product_screen/cubit.dart';
import '../../products_view/screens/product_screen.dart';
import '../../search/cubit/sreach_cubit.dart';
import '../../shopping_bag/widgets/custom_app_bar.dart';
import '../bloc/wishlist_cubit.dart';
import '../widgets/border_card.dart';
import '../widgets/wishlist_switcher.dart';

class WishListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> borders;
  const WishListScreen({super.key, required this.borders});

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
            SizedBox(height: 16.h),
            BlocBuilder<WishListCubit, WishListState>(
              builder: (context, state) {
                return Expanded(
                  child: context.read<WishListCubit>().kindOfOrder == "Borders"
                      ? borders.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 50.h),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Image(
                                    height: 200.h,
                                    image: const AssetImage(
                                        'assets/icons/saadHart.png'),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Text(
                                    "No reviews published",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              itemCount: borders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0
                                    ? SizedBox(height: 15.h)
                                    : FutureBuilder(
                                        future: sl
                                            .get<DataSource>()
                                            .getProductsInBorder(
                                                borders[index]['id']),
                                        builder: (context, snapshot) {
                                          return snapshot.hasData
                                              ? BorderCard(
                                                  borderName: borders[index]
                                                      ['borderName'],
                                                  borderProducts:
                                                      snapshot.data!,
                                                )
                                              : const SizedBox.shrink();
                                        });
                              })
                      : FutureBuilder(
                          future: sl.get<DataSource>().getAllFavoritProducts(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            } else {
                              return AnimationLimiter(
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: .7.h,
                                    crossAxisSpacing: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    ProductModel product = ProductModel.fromMap(
                                        snapshot.data![index]);
                                    //* this is the animation
                                    return AnimationConfiguration.staggeredGrid(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      position: index,
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                        // curve: Curves.fastOutSlowIn,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: GestureDetector(
                                          onTap: () {
                                            ProductCubit productCubit =
                                                BlocProvider.of<ProductCubit>(
                                                    context);
                                            productCubit.widthOfPrice = 145;
                                            productCubit.hidden = false;
                                            productCubit
                                                .getReviws(product.id)
                                                .then((value) {
                                              productCubit
                                                  .getSimilarProducts(product)
                                                  .then((value) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductScreen(
                                                    categoryName: 'Wish list',
                                                    fromPage: 'WishList',
                                                    fromPageTitle: 'WishList',
                                                    searchCubit: BlocProvider
                                                        .of<SearchCubit>(
                                                            context),
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
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: const Offset(
                                                              0, 4),
                                                          color: Colors.black
                                                              .withOpacity(.25),
                                                          blurRadius: 2)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Stack(
                                                  alignment: const Alignment(
                                                      .80, -.89),
                                                  children: [
                                                    Image.asset(
                                                      product.imgUrl
                                                          .split('|')[0]
                                                          .trim(),
                                                      fit: BoxFit.cover,
                                                      height: 206.h,
                                                      width: 141.w,
                                                    ),
                                                    Positioned(
                                                      right: 2.w,
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                  height: 33.h,
                                                                  width: 33.h,
                                                                  alignment: Alignment.center,
                                                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                  child: product.isFavorite
                                                                      ? const Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Color(0xffFF6E6E),
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Color(0xffD8D8D8),
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
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          color: const Color(
                                                              0xff393939)),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "${product.price} \$",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          color: const Color(
                                                              0xFFD57676),
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
                                                      color: const Color(
                                                          0xFF828282),
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
                              );
                            }
                          }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
