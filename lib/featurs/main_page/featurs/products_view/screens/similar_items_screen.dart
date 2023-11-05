import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/models/product_model.dart';
import '../../search/cubit/sreach_cubit.dart';
import '../cubits/product_screen/cubit.dart';
import '../widgets/product_view_widgets.dart';
import 'product_screen.dart';

class SimilarItemsScreen extends StatelessWidget {
  final ProductCubit productCubit;
  final ProductModel product;
  final String searchWord;
  final String categoryName;
  final SearchCubit searchCubit;
  final List<Map<String, dynamic>> similarProducts;
  final String fromPage;

  const SimilarItemsScreen({
    super.key,
    required this.fromPage,
    required this.similarProducts,
    required this.searchCubit,
    required this.product,
    required this.searchWord,
    required this.categoryName,
    required this.productCubit,
  });

  @override
  Widget build(BuildContext context) {
    void navigateToProductScrean(ProductModel productModel) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ProductScreen(
          searchWord: searchWord,
          product: productModel,
          searchCubit: searchCubit,
          fromPage: fromPage,
          categoryName: categoryName,
          cubit: BlocProvider.of<ProductCubit>(context),
        ),
      ));
    }

    return WillPopScope(
      onWillPop: () async {
        productCubit.widthOfPrice = 145;
        productCubit.hidden = false;
        Map<String, dynamic> productMap =
            await productCubit.getProductById(product.id);
        navigateToProductScrean(ProductModel.fromMap(productMap));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    CustomIconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () async {
                        productCubit.widthOfPrice = 145;
                        productCubit.hidden = false;
                        Map<String, dynamic> productMap =
                            await productCubit.getProductById(product.id);
                        navigateToProductScrean(
                            ProductModel.fromMap(productMap));
                      },
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Similar Items',
                      style: TextStyle(
                        color: const Color(0xFF171717),
                        fontSize: 24.sp,
                        fontFamily: 'Tenor Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.06,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.only(left: 75.w),
                child: Text(
                  '${similarProducts.length} items',
                  style: TextStyle(
                    color: const Color(0xFF979797),
                    fontSize: 16.sp,
                    fontFamily: 'Tenor Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.06,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              const SizedBox(width: 0),
              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: SizedBox(
                  width: 393.w,
                  height: 673.h,
                  // ?if this going down (فرشت) with you
                  // ? change the childAspectRatio
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    //* _____________here_______________
                    //* I calculate it and this is the answer :)
                    childAspectRatio: 0.65, //0.6373958,
                    children: similarProducts
                        .map((e) => GestureDetector(
                            onTap: () async {
                              Map<String, dynamic> productsMap =
                                  await productCubit.getProductById(e['id']);
                              ProductModel productModel =
                                  ProductModel.fromMap(productsMap);
                              navigateToProductScrean(productModel);
                            },
                            child: SimilarItem(
                              product: ProductModel.fromMap(e),
                              productCubit: productCubit,
                            )))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
