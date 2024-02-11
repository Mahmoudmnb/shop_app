import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../home/models/product_model.dart';
import '../../products_view/cubits/product_screen/cubit.dart';
import '../../products_view/screens/product_screen.dart';
import '../cubit/sreach_cubit.dart';
import '../widgets/end_drawer.dart';

class CategoryViewPage extends StatefulWidget {
  final List<Map<String, dynamic>> categoryProducts;
  final String categoryName;
  final String searchWord;
  const CategoryViewPage({
    super.key,
    required this.searchWord,
    required this.categoryName,
    required this.categoryProducts,
  });

  @override
  State<CategoryViewPage> createState() => _CategoryViewPageState();
}

class _CategoryViewPageState extends State<CategoryViewPage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> categoryProducts;
  late String categoryName;
  @override
  void initState() {
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
    categoryName = cubit.selectedCategory;
    return SafeArea(
        child: Scaffold(
      endDrawer: EndDrawer(
        oldCategoryName: widget.categoryName,
        searchWord: searchController.text,
        fromPage: 'categoryView',
        searchController: searchController,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(children: [
          SizedBox(height: 15.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  cubit.changeCategoryViewSearch(false);
                  Navigator.of(context)
                      .pop({'searchWord': searchController.text});
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
              SizedBox(width: 10.w),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  categoryName = cubit.selectedCategory;
                  return SizedBox(
                    width: 320.w,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: cubit.isCategoryViewSearch ? 0.w : 250.w,
                          height: cubit.isCategoryViewSearch ? 0 : 27.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            categoryName,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Tenor Sans',
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: cubit.isCategoryViewSearch ? 300.w : 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            clipBehavior: Clip.antiAlias,
                            child: TextField(
                              cursorColor: Colors.black,
                              onSubmitted: (value) async {
                                searchInCategory(cubit);
                              },
                              controller: searchController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF9B9B9B),
                                      fontSize: 20.sp),
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      searchInCategory(cubit);
                                    },
                                    icon: Icon(
                                      color: const Color(0xFFA4A4A4),
                                      Icons.search,
                                      size: 20.sp,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xff9B9B9B),
                                    ),
                                    onTap: () async {
                                      searchController.text = '';
                                      FocusScope.of(context).unfocus();
                                      cubit.changeCategoryViewSearch(false);
                                      await cubit
                                          .searchInCategory(
                                              null, widget.categoryName)
                                          .then((value) {
                                        log(value.toString());
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
                          width: cubit.isCategoryViewSearch ? 0 : 40.w,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                searchController.text = '';
                                cubit.changeCategoryViewSearch(true);
                                FocusScope.of(context).requestFocus();
                              },
                              icon: AnimatedOpacity(
                                opacity: cubit.isCategoryViewSearch ? 0 : 1,
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
          SizedBox(height: 15.h),
          Row(
            children: [
              SizedBox(width: 40.w),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  int length = categoryProducts.length;
                  if (state is SearchResults) {
                    length = state.searchResult.length;
                  }
                  if (state is SaveState) {
                    length = state.categoryProducts.length;
                  }
                  return Text(
                    "$length items ",
                    style: TextStyle(
                        color: const Color(0xFF979797),
                        fontSize: 16.sp,
                        fontFamily: 'Tenor Sans'),
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
              SizedBox(width: 15.w)
            ],
          ),
          SizedBox(height: 15.h),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              log(state.toString());
              if (state is GetCategoryProducts) {
                categoryProducts = state.categoryProducts;
              } else if (state is SaveState) {
                log(state.categoryProducts.toString());
                categoryProducts = state.categoryProducts;
              } else if (state is SearchResults) {
                categoryProducts = state.searchResult;
              }
              return categoryProducts.isEmpty
                  ? Column(
                      children: [
                        const Image(
                          image: AssetImage('assets/icons/notFound.jpeg'),
                        ),
                        Text(
                          "No products founded",
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.grey[600]),
                        )
                      ],
                    )
                  : Expanded(
                      //* this widget have to be exit for (AnimationConfiguration)
                      child: AnimationLimiter(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                            fromPageTitle: '',
                                            categoryName: categoryName,
                                            fromPage: 'CategoryProducts',
                                            searchCubit: cubit,
                                            searchWord: searchController.text,
                                            product: product,
                                            cubit:
                                                BlocProvider.of<ProductCubit>(
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
                                                          child:
                                                              product.isFavorite
                                                                  ? const Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Color(
                                                                          0xffFF6E6E),
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .favorite,
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
                                                  color:
                                                      const Color(0xff393939)),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${product.price} \$",
                                              style: TextStyle(
                                                  fontFamily: 'Tenor Sans',
                                                  color:
                                                      const Color(0xFFD57676),
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
                    );
            },
          ),
        ]),
      ),
    ));
  }

  searchInCategory(SearchCubit cubit) async {
    if (searchController.text.isNotEmpty) {
      cubit.searchInCategory(searchController.text, categoryName.toLowerCase());
    }
  }
}
