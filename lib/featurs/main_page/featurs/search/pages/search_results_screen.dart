import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../injection.dart';
import '../../../data_source/data_source.dart';
import '../../home/models/product_model.dart';
import '../../products_view/cubits/product_screen/cubit.dart';
import '../../products_view/screens/product_screen.dart';
import '../cubit/sreach_cubit.dart';
import '../widgets/end_drawer.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> searchProducts;
  final String searchWord;
  final String fromPage;
  const SearchResultScreen(
      {super.key,
      required this.fromPage,
      required this.searchProducts,
      required this.searchWord});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> searchProducts;
  @override
  void initState() {
    searchController = TextEditingController(text: widget.searchWord);
    searchProducts = widget.searchProducts;
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
        searchWord: searchController.text,
        fromPage: 'SearchResult',
        searchController: searchController,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(children: [
          SizedBox(height: 30.h),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop({'searchWord': searchController.text});
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 36.h,
                    width: 35.w,
                    margin: EdgeInsets.all(5.sp),
                    padding: EdgeInsets.only(left: 10.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                    )),
              ),
              SizedBox(width: 10.w),
              Expanded(
                  child: TextField(
                cursorColor: Colors.black,
                controller: searchController,
                style:
                    TextStyle(fontSize: 24.sp, color: const Color(0xff797979)),
                onSubmitted: (value) {
                  search(cubit);
                },
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                  onTap: () {
                    searchController.clear();
                  },
                  child: IconButton(
                    onPressed: () {
                      search(cubit);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30.sp,
                    ),
                  ),
                )),
              )),
              SizedBox(width: 10.w)
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              SizedBox(width: 55.w),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  int length = searchProducts.length;
                  if (state is SearchResults) {
                    length = state.searchResult.length;
                  }
                  return Text(
                    "$length items founded",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: const Color(0xFF979797),
                        fontSize: 16.sp),
                  );
                },
              ),
              const Spacer(),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    cubit.openDrawer(context);
                  },
                  child: Image(
                    image: const AssetImage('assets/images/Filter_big.png'),
                    height: 22.h,
                    width: 22.w,
                  ),
                );
              }),
              SizedBox(
                width: 2.w,
              )
            ],
          ),
          SizedBox(height: 30.h),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              log(state.toString());
              if (state is GetCategoryProducts) {
                searchProducts = state.categoryProducts;
              } else if (state is SaveState) {
                searchProducts = state.categoryProducts;
              } else if (state is SearchResults) {
                log(state.searchResult.toString());
                searchProducts = state.searchResult;
              }

              return Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: searchProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.h,
                  ),
                  itemBuilder: (context, index) {
                    ProductModel product =
                        ProductModel.fromMap(searchProducts[index]);
                    return GestureDetector(
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
                                searchCubit: cubit,
                                fromPage: 'SearchReasults',
                                searchWord: searchController.text,
                                product: product,
                                cubit: BlocProvider.of<ProductCubit>(context),
                              ),
                            ));
                          });
                        });
                      },
                      child: SizedBox(
                        width: 141.w,
                        height: 248.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    right: 8.w,
                                    child: GestureDetector(
                                        onTap: () {
                                          // cubit.setFavorateProduct(
                                          //     product.id, !product.isFavorite);
                                          // cubit.search(searchController.text);
                                        },
                                        child: Container(
                                            height: 33.h,
                                            width: 33.h,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: product.isFavorite
                                                ? const Icon(
                                                    Icons.favorite,
                                                    color: Color(0xffFF6E6E),
                                                  )
                                                : const Icon(
                                                    Icons.favorite,
                                                    color: Color(0xffD8D8D8),
                                                  ))),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            SizedBox(
                              height: 20.h,
                              width: 141.w,
                              child: Row(
                                children: [
                                  Text(
                                    product.makerCompany,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'Tenor Sans'),
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
                              height: 20.h,
                              width: 141.w,
                              child: Text(
                                product.name,
                                style: TextStyle(
                                    fontFamily: 'Tenor Sans',
                                    fontSize: 11.sp,
                                    color: const Color(0xFF828282)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ]),
      ),
    ));
  }

  search(SearchCubit cubit) async {
    if (searchController.text.isNotEmpty) {
      sl.get<DataSource>().setSearchHistory(searchController.text);
      await cubit.search(searchController.text.trim());
    }
  }
}
