import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/injection.dart';

import '../../search/cubit/sreach_cubit.dart';
import '../blocs/discount/discount_products_bloc.dart';
import '../models/product_model.dart';
import '../widgets/collections_spacer.dart';
import '../widgets/discount_image.dart';
import '../widgets/recommended_image.dart';
import '../widgets/trendy_image.dart';
import 'home_pages.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> trindyProducts;
  const HomePage({super.key, required this.trindyProducts});

  @override
  Widget build(BuildContext context) {
    // context
    //     .read<DiscountProductsBloc>()
    //     .add(GetDiscountProducts(discountProducts: disCountProducts));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          SizedBox(height: 10.h),
          SizedBox(
            height: 160.h,
            width: 353.w,
            child: Image.asset(
              'assets/images/capture.jpg',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 15.h),
          BlocBuilder<DiscountProductsBloc, DiscountProductsState>(
            builder: (context, state) {
              bool isDiscountUpdated = false;
              if (state is IsDisCountUpdatedEvent) {
                isDiscountUpdated = state.isDiscountUpdated;
              }
              return CollectionsSpacer(
                  isNew: isDiscountUpdated,
                  onTap: () {
                    context.read<SearchCubit>().reset('', false);
                    context
                        .read<SearchCubit>()
                        .searchInSeeAllProducts(null, 'Discount', null)
                        .then((disCountProducts) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => SeeAllProductsPage(
                            searchWord: '',
                            categoryName: 'Discount',
                            categoryProducts: disCountProducts),
                      ))
                          .then((value) async {
                        var data =
                            await sl.get<DataSource>().getDiscountsProducts();
                        for (var element in data) {
                          ProductModel productModel =
                              ProductModel.fromMap(element);
                          if (productModel.isDisCountUpdated) {
                            if (context.mounted) {
                              context.read<DiscountProductsBloc>().add(
                                  ChangeIsDisCountUpdated(
                                      isDisCountUpdated: true));
                            }
                            break;
                          }
                        }
                      });
                    });
                  },
                  collectoinTitle: 'Discount');
            },
          ),
          SizedBox(height: 15.h),
          //! Discount products
          FutureBuilder(
              future: sl.get<DataSource>().getDiscountsProducts(),
              builder: (_, snapshoot) {
                if (snapshoot.hasData) {
                  bool key = false;
                  for (var element in snapshoot.data!) {
                    if (ProductModel.fromMap(element).isDisCountUpdated) {
                      key = true;
                      break;
                    }
                  }
                  context
                      .read<DiscountProductsBloc>()
                      .add(ChangeIsDisCountUpdated(isDisCountUpdated: key));
                }
                return snapshoot.hasData
                    ? SizedBox(
                        width: double.infinity,
                        height: 182.h,
                        child: ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshoot.data!.length < 6
                                ? snapshoot.data!.length
                                : 6,
                            itemBuilder: (context, index) {
                              ProductModel product =
                                  ProductModel.fromMap(snapshoot.data![index]);
                              return DisCountImage(
                                  makerCompany: product.makerCompany,
                                  imageUrl: product.imgUrl,
                                  price: product.price.toString(),
                                  productName: product.name,
                                  discount: product.disCount.toString());
                            }))
                    : SizedBox.fromSize();
              }),
          SizedBox(height: 15.h),
          //! trendy products
          CollectionsSpacer(
              isNew: false,
              onTap: () async {
                context.read<SearchCubit>().reset('', false);
                List<Map<String, dynamic>> trendyProducts =
                    await sl.get<DataSource>().getTrendyProducts();
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeAllProductsPage(
                        searchWord: '',
                        categoryName: 'Trendy',
                        categoryProducts: trendyProducts),
                  ));
                }
              },
              collectoinTitle: 'Trendy'),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.only(left: 3.w, top: 1.h),
            width: 123.w,
            height: 180.h,
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              scrollDirection: Axis.horizontal,
              itemCount: trindyProducts.length,
              itemBuilder: (_, index) => TrendyImage(
                makerCompany: trindyProducts[index]['makerCompany'],
                imageUrl: trindyProducts[index]['imgUrl'].split('|')[0],
                price: (trindyProducts[index]['price'] as int).toStringAsFixed(1),
                productName: trindyProducts[index]['name'],
              ),
            ),
          ),
          //! Recommended products
          CollectionsSpacer(
              isNew: false,
              onTap: () async {
                context.read<SearchCubit>().reset('', false);
                List<Map<String, dynamic>> recommendedProducts =
                    await sl.get<DataSource>().getRecommendedProducts();
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeAllProductsPage(
                        searchWord: '',
                        categoryName: 'Recommended',
                        categoryProducts: recommendedProducts),
                  ));
                }
              },
              collectoinTitle: 'Recommended'),
          SizedBox(height: 15.h),
          FutureBuilder(
              future: sl.get<DataSource>().getRecommendedProducts(),
              builder: (context, snpashoot) {
                return snpashoot.hasData
                    ? SizedBox(
                        height: 78.h,
                        child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,

                          itemCount: snpashoot.data!.length,

                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            ProductModel product =
                                ProductModel.fromMap(snpashoot.data![index]);
                            return RecommendedImage(
                              companyMaker: product.makerCompany,
                              imageUrl: product.imgUrl.split('|')[0],
                              productPrice: '${product.price} \$',
                              productNamge: product.name,
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              }),
          SizedBox(height: 15.h),
          //! new products
          BlocBuilder<DiscountProductsBloc, DiscountProductsState>(
            builder: (context, state) {
              bool isFounded = false;
              if (state is IsNewProductsFounded) {
                isFounded = state.isFounded;
              }
              return CollectionsSpacer(
                  isNew: isFounded,
                  onTap: () async {
                    context.read<SearchCubit>().reset('', false);
                    List<Map<String, dynamic>> newestProducts =
                        await sl.get<DataSource>().getNewestProducts();
                    if (context.mounted) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => SeeAllProductsPage(
                            searchWord: '',
                            categoryName: 'New',
                            categoryProducts: newestProducts),
                      ))
                          .then((value) async {
                        var data =
                            await sl.get<DataSource>().getNewestProducts();
                        for (var element in data) {
                          ProductModel productModel =
                              ProductModel.fromMap(element);
                          if (productModel.isNew) {
                            if (context.mounted) {
                              context.read<DiscountProductsBloc>().add(
                                  ChangeIsNewProductsFounded(isFounded: true));
                            }
                            break;
                          }
                        }
                      });
                    }
                  },
                  collectoinTitle: 'New');
            },
          ),
          SizedBox(height: 15.h),
          FutureBuilder(
              future: sl.get<DataSource>().getNewestProducts(),
              builder: (_, snapshoot) {
                if (snapshoot.hasData) {
                  bool key = false;
                  for (var element in snapshoot.data!) {
                    if (ProductModel.fromMap(element).isNew) {
                      key = true;
                      break;
                    }
                  }
                  context
                      .read<DiscountProductsBloc>()
                      .add(ChangeIsNewProductsFounded(isFounded: key));
                  return Container(
                    padding: EdgeInsets.only(left: 3.w, top: 1.h),
                    width: 123.w,
                    height: 180.h,
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshoot.data!.length,
                      itemBuilder: (_, index) {
                        ProductModel productModel =
                            ProductModel.fromMap(snapshoot.data![index]);
                        return TrendyImage(
                          makerCompany: productModel.makerCompany,
                          imageUrl: productModel.imgUrl,
                          price: productModel.price.toString(),
                          productName: productModel.name,
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
          // CollectionsSpacer(onTap: () {}, collectoinTitle: 'New'),
          // // ! Top collection
          // SizedBox(height: 15.h),
          // const TopCollectionImage(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
