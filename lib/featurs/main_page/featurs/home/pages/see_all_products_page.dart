import 'dart:developer';

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
import '../../search/widgets/end_drawer.dart';
import '../blocs/discount/discount_products_bloc.dart';

class SeeAllProductsPage extends StatefulWidget {
  final List<Map<String, dynamic>> categoryProducts;
  final String categoryName;
  final String searchWord;
  const SeeAllProductsPage({
    super.key,
    required this.searchWord,
    required this.categoryName,
    required this.categoryProducts,
  });

  @override
  State<SeeAllProductsPage> createState() => _SeeAllProductsPageState();
}

class _SeeAllProductsPageState extends State<SeeAllProductsPage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> categoryProducts;
  late String categoryName;
  //! new
  bool isSearch = false;
  @override
  void initState() {
    if (widget.searchWord != '') {
      context
          .read<DiscountProductsBloc>()
          .add(ChangeIsSearchEvent(isSearch: true));
    }
    searchController = TextEditingController(text: widget.searchWord);
    categoryProducts = widget.categoryProducts;
    categoryName = widget.categoryName;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
    return SafeArea(
        child: Scaffold(
      endDrawer: EndDrawer(
        oldCategoryName: widget.categoryName,
        searchWord: searchController.text,
        fromPage: 'seeAll',
        fromPageTitle: widget.categoryName,
        searchController: searchController,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(children: [
          SizedBox(height: 15.w),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .read<DiscountProductsBloc>()
                      .add(ChangeIsSearchEvent(isSearch: false));
                  Navigator.of(context)
                      .pop({'searchWord': searchController.text});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 36.w,
                  width: 36.w,
                  padding: EdgeInsets.only(left: 5.w),
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
              SizedBox(width: 20.w),
              BlocBuilder<DiscountProductsBloc, DiscountProductsState>(
                builder: (context, state) {
                  if (state is IsSearchState) {
                    isSearch = state.isSearch;
                  }
                  return SizedBox(
                    width: 310.w,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: isSearch ? 0.w : 270.w,
                          height: isSearch ? 0 : 30.h,
                          child: Text(
                            categoryName,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: isSearch ? 310.w : 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            clipBehavior: Clip.antiAlias,
                            child: TextField(
                              maxLength: 50,
                              onSubmitted: (value) async {
                                FocusScope.of(context).unfocus();
                                searchIn(cubit);
                              },
                              cursorColor: Colors.black,
                              controller: searchController,
                              textAlign: TextAlign.start,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF9B9B9B),
                                      fontSize: 20.sp),
                                  iconColor: const Color(0xFFA4A4A4),
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      searchIn(cubit);
                                    },
                                    icon: Icon(
                                      color: const Color(0xFFA4A4A4),
                                      Icons.search,
                                      size: 25.sp,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xFFA4A4A4),
                                    ),
                                    onTap: () async {
                                      searchController.text = '';
                                      isSearch = false;
                                      FocusScope.of(context).unfocus();
                                      context.read<DiscountProductsBloc>().add(
                                          ChangeIsSearchEvent(isSearch: false));

                                      if (categoryName == 'Trendy') {
                                        List<Map<String, dynamic>>
                                            trendyProducts = await sl
                                                .get<DataSource>()
                                                .getTrendyProducts();
                                        categoryProducts = trendyProducts;
                                      } else if (categoryName ==
                                          'Recommended') {
                                        List<Map<String, dynamic>>
                                            recommendedProducts = await sl
                                                .get<DataSource>()
                                                .getRecommendedProducts();
                                        categoryProducts = recommendedProducts;
                                      }
                                      cubit
                                          .searchInSeeAllProducts(null,
                                              categoryName, categoryProducts)
                                          .then((allDiscountProducts) {
                                        context
                                            .read<DiscountProductsBloc>()
                                            .add(GetAllDiscountEvent(
                                                allDiscountProducts:
                                                    allDiscountProducts));
                                      });
                                    },
                                  ),
                                  fillColor: const Color(0xFFEAEAEA),
                                  filled: true,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: isSearch ? 0 : 40.w,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                searchController.text = '';
                                context
                                    .read<DiscountProductsBloc>()
                                    .add(ChangeIsSearchEvent(isSearch: true));
                                FocusScope.of(context).requestFocus();
                              },
                              icon: AnimatedOpacity(
                                opacity: isSearch ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.search,
                                  size: 30.sp,
                                ),
                              )),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(width: 55.w),
              BlocBuilder<DiscountProductsBloc, DiscountProductsState>(
                builder: (context, state) {
                  int length = categoryProducts.length;
                  if (state is SearchInDiscountResult) {
                    length = state.searchResult.length;
                  } else if (state is AllDiscountProductState) {
                    length = state.allDiscountProducts.length;
                  }
                  return Text(
                    "$length items founded",
                    style: TextStyle(
                        color: const Color(0xFF979797), fontSize: 16.sp),
                  );
                },
              ),
              const Spacer(),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    cubit.openDrawer(context);
                  },
                  child: Image(
                    image: const AssetImage('assets/images/Filter_big.png'),
                    height: 22.h,
                    width: 22.w,
                  ),
                );
              }),
              SizedBox(width: 2.w)
            ],
          ),
          SizedBox(height: 30.h),
          BlocBuilder<DiscountProductsBloc, DiscountProductsState>(
            builder: (context, state) {
              log(state.toString());
              if (state is SearchInDiscountResult) {
                categoryProducts = state.searchResult;
              } else if (state is AllDiscountProductState) {
                categoryProducts = state.allDiscountProducts;
              }
              return Expanded(
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoryProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .7.h,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      ProductModel product =
                          ProductModel.fromMap(categoryProducts[index]);
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        child: ScaleAnimation(
                          curve: Curves.fastEaseInToSlowEaseOut,
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
                                      categoryName: categoryName,
                                      fromPage: 'seeAll',
                                      searchCubit: cubit,
                                      searchWord: searchController.text,
                                      product: product,
                                      fromPageTitle: categoryName,
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
                                                onTap: () {
                                                  // if (searchController.text ==
                                                  //     '') {
                                                  //   cubit
                                                  //       .setFavorateProduct(
                                                  //           product.id,
                                                  //           !product.isFavorite)
                                                  //       .then((value) {
                                                  //     cubit
                                                  //         .searchInSeeAllProducts(
                                                  //             null,
                                                  //             categoryName,
                                                  //             categoryProducts)
                                                  //         .then((searchResult) {
                                                  //       context
                                                  //           .read<
                                                  //               DiscountProductsBloc>()
                                                  //           .add(SearchInDiscount(
                                                  //               searchResult:
                                                  //                   searchResult));
                                                  //     });
                                                  //   });
                                                  // } else {
                                                  //   cubit
                                                  //       .setFavorateProduct(
                                                  //           product.id,
                                                  //           !product.isFavorite)
                                                  //       .then((value) {
                                                  //     cubit
                                                  //         .searchInSeeAllProducts(
                                                  //             searchController
                                                  //                 .text,
                                                  //             categoryName,
                                                  //             categoryProducts)
                                                  //         .then((searchResult) {
                                                  //       context
                                                  //           .read<
                                                  //               DiscountProductsBloc>()
                                                  //           .add(SearchInDiscount(
                                                  //               searchResult:
                                                  //                   searchResult));
                                                  //     });
                                                  //   });
                                                  // }
                                                },
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
                                SizedBox(height: 15.h),
                                SizedBox(
                                  height: 17.h,
                                  width: 141.w,
                                  child: Row(
                                    children: [
                                      //! this sizedBox for ellipis
                                      SizedBox(
                                        width: 100.w,
                                        child: Text(
                                          product.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: 'Tenor Sans'),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${product.price} \$",
                                        style: TextStyle(
                                            color: const Color(0xFFD57676),
                                            fontSize: 10.sp),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                  width: 141.w,
                                  child: Text(
                                    product.makerCompany,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: const Color(0xFF828282),
                                        fontSize: 11.sp,
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
              );
            },
          ),
        ]),
      ),
    ));
  }

  searchIn(SearchCubit cubit) async {
    if (searchController.text != '') {
      if (categoryName == 'Recommended') {
        categoryProducts = await sl.get<DataSource>().getRecommendedProducts();
      } else if (categoryName == 'Trendy') {
        categoryProducts = await sl.get<DataSource>().getTrendyProducts();
      }
      cubit
          .searchInSeeAllProducts(
              searchController.text, categoryName, categoryProducts)
          .then((searchResult) {
        log(searchResult.toString());
        context
            .read<DiscountProductsBloc>()
            .add(SearchInDiscount(searchResult: searchResult));
      });
    }
  }
}
