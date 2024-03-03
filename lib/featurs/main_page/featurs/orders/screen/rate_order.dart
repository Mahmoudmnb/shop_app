import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/core/internet_info.dart';
import 'package:shop_app/injection.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:toast/toast.dart';

import '../../../data_source/data_source.dart';
import '../../products_view/models/review_model.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/build_back_arrow.dart';

class RatePage extends StatelessWidget {
  final int? productId;
  const RatePage({super.key, this.productId});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 30.h),
              Row(
                children: [
                  const BuildBackArrow(),
                  SizedBox(width: 20.w),
                  Text(
                    'feedback',
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.only(left: 10.w),
                width: double.infinity,
                child: Text(
                  productId == null
                      ? 'Share your opinion in this app'
                      : "Share your opinion in this product",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Tenor Sans',
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF393939)),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                    productId == null
                        ? 'How much do you rate app?'
                        : 'How much do you rate product?',
                    style: const TextStyle(
                        color: Color(0xFF6D6D6D), fontFamily: 'Tenor Sans')),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      return SmoothStarRating(
                        color: Colors.yellow,
                        rating: context.watch<OrdersCubit>().rating,
                        onRatingChanged: (value) {
                          context.read<OrdersCubit>().changeRating(value);
                        },
                      );
                    },
                  ),
                  const Spacer()
                ],
              ),
              SizedBox(height: 40.h),
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(.15))
                        ]),
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: Colors.black,
                          maxLength: 50,
                          onTapOutside: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            context.read<OrdersCubit>().numofcharcters();
                          },
                          controller:
                              context.watch<OrdersCubit>().opinionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              counter: Container(),
                              hintText: productId == null
                                  ? 'Would you like to write anything about this app?'
                                  : 'Would you like to write anything about this product?',
                              hintStyle: const TextStyle(
                                  color: Color(0XFF919191),
                                  fontFamily: 'Tenor Sans'),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10.w),
                          width: double.infinity,
                          child: Text(
                            '${context.watch<OrdersCubit>().character} characters',
                            textAlign: TextAlign.end,
                            style: const TextStyle(color: Color(0xFF919191)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.only(left: 10.w),
              //   child: const Text('Add a picture for your order',
              //       style: TextStyle(
              //           color: Color(0xFF6D6D6D),
              //           fontFamily: 'Tenor Sans')),
              // ),

              // SizedBox(height: 20.h),
              // Row(
              //   children: [
              //     SizedBox(width: 20.w),
              //     SizedBox(
              //         height: 70.h,
              //         child: const Image(
              //             image: AssetImage('assets/icons/Jackets.png'))),
              //     SizedBox(width: 20.w),
              //     SizedBox(
              //         height: 70.h,
              //         child: const Image(
              //             image: AssetImage('assets/icons/Jackets.png')))
              //   ],
              // ),
              SizedBox(height: 190.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    if (!context.read<OrdersCubit>().isLoading) {
                      if (context
                              .read<OrdersCubit>()
                              .opinionController
                              .text
                              .trim() ==
                          '') {
                        ToastContext().init(context);
                        Toast.show(
                            'sorry, but you have to write you opnion before send back',
                            duration: Toast.lengthLong);
                      } else {
                        context.read<OrdersCubit>().changeIsLoading(true);
                        InternetInfo.isconnected().then((value) async {
                          if (value) {
                            if (productId != null) {
                              ReviewModel reiviewModel = ReviewModel(
                                  email: Constant.currentUser!.email,
                                  description: context
                                      .read<OrdersCubit>()
                                      .opinionController
                                      .text
                                      .trim(),
                                  stars: context.read<OrdersCubit>().rating,
                                  date: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  userName: Constant.currentUser!.name,
                                  userImage: Constant.currentUser!.cloudImgUrl,
                                  productId: productId!);
                              await sl
                                  .get<DataSource>()
                                  .addReviewToCloud(reiviewModel);
                              await sl
                                  .get<DataSource>()
                                  .addReiviewToProduct(reiviewModel);
                              if (context.mounted) {
                                context
                                    .read<OrdersCubit>()
                                    .changeIsLoading(false);
                              }
                            } else {
                              await sl.get<DataSource>().rateApp(
                                    context
                                        .read<OrdersCubit>()
                                        .opinionController
                                        .text
                                        .trim(),
                                    context.read<OrdersCubit>().rating,
                                  );
                              if (context.mounted) {
                                context
                                    .read<OrdersCubit>()
                                    .changeIsLoading(false);
                              }
                              log('mnb');
                            }

                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } else {
                            context.read<OrdersCubit>().changeIsLoading(false);
                            ToastContext().init(context);
                            Toast.show('check your internet');
                          }
                        });
                      }
                    }
                  },
                  child: Ink(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: BlocBuilder<OrdersCubit, OrdersState>(
                      builder: (context, state) {
                        return context.read<OrdersCubit>().isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : Text(
                                "Send feedback",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DM Sans"),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
