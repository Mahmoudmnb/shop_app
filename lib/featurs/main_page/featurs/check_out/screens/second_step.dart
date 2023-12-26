import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/internet_info.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/check_out/screens/third_step.dart';
import 'package:shop_app/featurs/main_page/featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import 'package:shop_app/injection.dart';

import '../cubit/check_out_cubit.dart';
import '../widget/calculate_card.dart';
import '../widget/payment_method_card.dart';
import '../widget/point.dart';

class CheckOutScreen2 extends StatelessWidget {
  final String deliveryAddress;
  final String latitude;
  final String longitude;
  final double deliveryCost;

  const CheckOutScreen2(
      {super.key,
      required this.deliveryAddress,
      required this.latitude,
      required this.longitude,
      required this.deliveryCost});

  @override
  Widget build(BuildContext context) {
    context.read<CheckOutCubit>().agree = false;
    // List<String> payment = ['Credit Card', 'Paypal', 'Visa', 'Google play'];
    List<String> payment = ['Paypal'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image(
                      height: 40.w,
                      width: 40.w,
                      image: const AssetImage("assets/images/backicon.png"),
                    )),
                SizedBox(width: 10.w),
                Text(
                  "Check out",
                  style: TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
                )
              ],
            ),
          ),
          SizedBox(
            height: 740.h,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Column(children: [
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        const Spacer(),
                        Image(
                            height: 24.h,
                            image:
                                const AssetImage('assets/images/location.png')),
                        SizedBox(width: 10.w),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        SizedBox(width: 10.w),
                        Image(
                            height: 18.h,
                            image: const AssetImage('assets/images/card.png')),
                        SizedBox(width: 10.w),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        const CheckOutPoint(),
                        SizedBox(width: 10.w),
                        Image(
                            height: 25.h,
                            image: const AssetImage(
                                'assets/images/grey_check_out.png')),
                        const Spacer(),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      width: double.infinity,
                      child: Text(
                        "Payment",
                        style: TextStyle(
                            color: const Color(0xFF939393),
                            fontSize: 18.sp,
                            fontFamily: 'DM Sans'),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                      itemCount: payment.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PaymentMethodCard(
                          title: payment[index],
                        );
                      },
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //       left: 10.w, top: 15.h, right: 20.w, bottom: 15.h),
                    //   margin: EdgeInsets.symmetric(vertical: 15.h),
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //       boxShadow: [
                    //         BoxShadow(
                    //             offset: const Offset(0, 11),
                    //             blurRadius: 11,
                    //             color: Colors.black.withOpacity(0.04))
                    //       ],
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(5)),
                    //   child: Text(
                    //     "   +  Add Card",
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //         fontSize: 16.sp,
                    //         fontWeight: FontWeight.w600,
                    //         fontFamily: 'DM Sans'),
                    //   ),
                    // )
                  ]),
                ),
                SizedBox(height: 8.h),
                CalculateCard(
                  deliveryCost: deliveryCost,
                  productPrice: context.read<AddToCartCubit>().totalPrice(),
                ),
                SizedBox(height: 15.h),
                const Spacer(),
                BlocConsumer<CheckOutCubit, CheckOutState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    CheckOutCubit cubit = CheckOutCubit.get(context);
                    return Row(
                      children: [
                        SizedBox(width: 50.w),
                        Checkbox(
                            activeColor: Colors.black,
                            value: cubit.agree,
                            onChanged: (value) {
                              cubit.changeAgree(value!);
                            }),
                        GestureDetector(
                          onTap: () {
                            cubit.changeAgree(!cubit.agree);
                          },
                          child: const Row(
                            children: [
                              Text("I agree to "),
                              Text(
                                "Terms and conditions",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (context.read<CheckOutCubit>().agree) {
                      if (!context.read<CheckOutCubit>().isLoading) {
                        log('mnb');
                        context.read<CheckOutCubit>().changeIsLoading(true);
                        InternetInfo.isconnected().then((value) {
                          if (value) {
                            List<Map<String, dynamic>> p = [];
                            List<Map<String, dynamic>> product =
                                context.read<AddToCartCubit>().products;
                            double totalPrice =
                                context.read<AddToCartCubit>().totalPrice();
                            for (var element in product) {
                              p.add(
                                {
                                  "name": element['productName'],
                                  "quantity": element['quantity'],
                                  "price": element['price'].toString(),
                                  "currency": "USD"
                                },
                              );
                            }
                            context
                                .read<CheckOutCubit>()
                                .changeIsLoading(false);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PaypalCheckout(
                                  sandboxMode: true,
                                  clientId:
                                      "AQuqmSDLKtYJ5MWKpuxAO2zzIxIeBFlTN7nC2wDtzokwEqvzj-1rLUGEsDst9MIJmacfX4n69BK9CSna",
                                  secretKey:
                                      "EPq3lvVP9vliuW1fcfOyWArAlU_Zmbg6x-y_kHkgFzSlJGFNOQz6aila9mrzbUIl9UrxIiqcP5sHuzW4",
                                  returnURL: "success.snippetcoder.com",
                                  cancelURL: "cancel.snippetcoder.com",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total":
                                            '${double.parse((totalPrice + deliveryCost).toStringAsFixed(2))}',
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": '$totalPrice',
                                          "shipping":
                                              '${double.parse((deliveryCost).toStringAsFixed(2))}',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description":
                                          "The payment transaction description.",
                                      "item_list": {
                                        "items": p,
                                        // shipping address is Optional
                                        "shipping_address": const {
                                          "recipient_name": "Raman Singh",
                                          "line1": "Delhi",
                                          "line2": "",
                                          "city": "Delhi",
                                          "country_code": "IN",
                                          "postal_code": "11001",
                                          "phone": "+00000000",
                                          "state": "Texas"
                                        },
                                      }
                                    }
                                  ],
                                  note: "PAYMENT_NOTE",
                                  onSuccess: (Map params) async {
                                    sl
                                        .get<DataSource>()
                                        .addOrdersToCloudDataBase(
                                            product,
                                            totalPrice + deliveryCost,
                                            deliveryAddress,
                                            context
                                                .read<CheckOutCubit>()
                                                .selectMethod,
                                            latitude,
                                            longitude)
                                        .then((value) async {
                                      await sl
                                          .get<DataSource>()
                                          .clearAddToCartTable();
                                      log('done');
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const CheckOutScreen3(),
                                        ));
                                      }
                                    });
                                    log("onSuccess: $params");
                                  },
                                  onError: (error) {
                                    log("onError: $error");
                                    showMessage(context,
                                        'Please you have to turn on VPN');
                                    context
                                        .read<CheckOutCubit>()
                                        .changeIsLoading(false);
                                    Navigator.of(context).pop(true);
                                  },
                                  onCancel: () {
                                    log('cancelled:');
                                  },
                                ),
                              ),
                            );
                          } else {
                            context
                                .read<CheckOutCubit>()
                                .changeIsLoading(false);
                            showMessage(
                                context, 'Check you internet connection ');
                          }
                        });
                      }
                    } else {
                      showMessage(context, 'You have to accept to our terms ');
                    }
                  },
                  child: BlocBuilder<CheckOutCubit, CheckOutState>(
                    builder: (context, state) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 24.h, horizontal: 25.w),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 13.h,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: context.read<CheckOutCubit>().isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                "Place Order",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        backgroundColor: Colors.grey,
        content: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18.sp),
          ),
        )));
  }
}
