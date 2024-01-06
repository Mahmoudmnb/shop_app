import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/models/product_model.dart';
import '../../../search/cubit/sreach_cubit.dart';
import '../../cubits/product_screen/cubit.dart';
import '../product_view_widgets.dart';

class ProductDetails extends StatelessWidget {
  final ProductCubit cubit;
  final ProductModel product;
  final Function(List<Map<String, dynamic>>) getAvrOfStars;
  final double avrOfStars;
  final List<String> sizes;
  final List<Color> colors;
  final List<Map<String, dynamic>> similarProducts;
  final String searchWord;
  final String categoryName;
  final SearchCubit searchCubit;
  final String fromPage;
  final bool hidden;

  const ProductDetails(
      {super.key,
      required this.fromPage,
      required this.cubit,
      required this.product,
      required this.getAvrOfStars,
      required this.colors,
      required this.sizes,
      required this.avrOfStars,
      required this.similarProducts,
      required this.searchCubit,
      required this.searchWord,
      required this.categoryName,
      required this.hidden});

  @override
  Widget build(BuildContext context) {
    //* this widget is very good it is like model bottom sheet
    //* and more flexible and you have to use it with [Stack]
    return DraggableScrollableSheet(
      snap: true,
      initialChildSize: 0.49,
      minChildSize: 0.49,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              BlocBuilder<ProductCubit, ProductStates>(
                builder: (context, state) {
                  return Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: context.read<ProductCubit>().hidden
                                ? const Radius.circular(0)
                                : const Radius.circular(15),
                            topRight: context.read<ProductCubit>().hidden
                                ? const Radius.circular(0)
                                : const Radius.circular(15))),
                  );
                },
              ),
              Container(
                color: Colors.white,
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                width: 393.w,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25.w, right: 15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25.5.h),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFFDFDFDF),
                                  ),
                                  width: 100.w,
                                  height: 5.1.h,
                                ),
                              ),
                              SizedBox(height: 17.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontFamily: 'Tenor Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 3.0, bottom: 1),
                                                child: Icon(
                                                  Icons.star,
                                                  size: 14.sp,
                                                  color:
                                                      const Color(0xFFFFC120),
                                                ),
                                              ),
                                            ),
                                            // !here is the evaluation
                                            TextSpan(
                                              text:
                                                  avrOfStars.toStringAsFixed(2),
                                              style: TextStyle(
                                                color: const Color(0xFF6D6D6D),
                                                fontSize: 12.sp,
                                                letterSpacing: .2,
                                                fontFamily: 'DM Sans',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 70.w,
                                    height: 42.5.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEEEEE),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          child: const Icon(Icons.remove,
                                              size: 14),
                                          onTap: () {
                                            cubit.removeAmountOfProduct();
                                          },
                                        ),
                                        BlocBuilder<ProductCubit,
                                            ProductStates>(
                                          builder: (context, state) {
                                            String amountOfProducts = cubit
                                                .amountOfProduct
                                                .toString();
                                            if (state
                                                is ChangeProductAmountState) {
                                              amountOfProducts = cubit
                                                  .amountOfProduct
                                                  .toString();
                                            }
                                            return Text(
                                              amountOfProducts,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                              ),
                                            );
                                          },
                                        ),
                                        InkWell(
                                          child:
                                              const Icon(Icons.add, size: 14),
                                          onTap: () {
                                            cubit.addAmountOfProduct();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 3.h),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  product.makerCompany,
                                  style: TextStyle(
                                    color: const Color(0xFF9B9B9B),
                                    fontSize: 16.sp,
                                    fontFamily: 'Tenor Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.06,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 22.h),
                              SizedBox(
                                width: 382.2.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Color',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontFamily: 'Tenor Sans',
                                            fontWeight: FontWeight.bold,
                                            height: 1.06,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: 17.h),
                                        // !Color
                                        SizedBox(
                                          height: 22,
                                          width: 170.w,
                                          child: SetColor(
                                            colors: colors,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Size',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontFamily: 'Tenor Sans',
                                            fontWeight: FontWeight.bold,
                                            height: 1.06,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: 17.h),
                                        //! Size
                                        SizedBox(
                                          height: 22,
                                          width: 136.5.w,
                                          child: SetSize(sizes: sizes),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 8.5.h),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Text(
                                'Description',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: 'Tenor Sans',
                                  fontWeight: FontWeight.bold,
                                  height: 1.06,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                constraints: BoxConstraints(minHeight: 68.h),
                                width: 393.w,
                                child: Text(
                                  product.discription,
                                  style: TextStyle(
                                    // overflow: TextOverflow.ellipsis,
                                    wordSpacing: 1,
                                    color: const Color(0xFF6C6C6C),
                                    fontSize: 16.sp,
                                    fontFamily: 'Tenor Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.06,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 11.7.w),
                                child: const Divider(),
                              ),
                              SizedBox(height: 17.h),
                              ReviewsCard(
                                  cubit: cubit,
                                  avrOfStars: avrOfStars,
                                  getAvrOfStars: getAvrOfStars)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    SimilarProductsCard(
                      categoryName: categoryName,
                      fromPage: fromPage,
                      cubit: cubit,
                      searchCubit: searchCubit,
                      searchWord: searchWord,
                      product: product,
                    ),
                    SizedBox(height: 13.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
