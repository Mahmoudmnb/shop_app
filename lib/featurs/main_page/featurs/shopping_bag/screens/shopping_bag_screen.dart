import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/injection.dart';
import 'package:toast/toast.dart';

import '../../../../../core/internet_info.dart';
import '../../check_out/cubit/check_out_cubit.dart';
import '../../check_out/screens/first_step.dart';
import '../../home/models/product_model.dart';
import '../../products_view/models/add_to_cart_product_model.dart';
import '../cubits/products_cubit/products_cubit.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/shopping_bag_body.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});
  Future<void> goToNextPage(BuildContext context) async {
    var data = context.read<AddToCartCubit>().products;
    String ids = '';
    for (var element in data) {
      ids += '${element['productId']}|';
    }
    int l = ids.length;
    ids = ids.substring(0, l - 1);
    var dddd = await sl.get<DataSource>().getProductsByIds(ids);
    String productNamesForColors = '';
    String productNamesForSizes = '';
    String productNamesForDeletedProducts = '';
    if (dddd.length != data.length) {
      int j = 0;
      if (dddd.isNotEmpty) {
        for (var i = 0; i < data.length; i++) {
          if (data[i]['productName'] != dddd[j]['name']) {
            productNamesForDeletedProducts += '${data[i]['productName']},';
          } else {
            j++;
          }
        }
      } else {
        for (var i = 0; i < data.length; i++) {
          productNamesForDeletedProducts += '${data[i]['productName']},';
        }
      }
    } else {
      for (var i = 0; i < dddd.length; i++) {
        ProductModel product = ProductModel.fromMap(dddd[i]);
        AddToCartProductModel cartProductModel =
            AddToCartProductModel.fromMap(data[i]);
        if (!product.colors.contains(cartProductModel.color)) {
          productNamesForColors += '${product.name},';
        }
        if (!product.sizes.contains(cartProductModel.size)) {
          productNamesForSizes += '${product.name},';
        }
      }
    }
    if (context.mounted) {
      context.read<AddToCartCubit>().setIsProceedButtonLoading = false;
      if (productNamesForColors == '' &&
          productNamesForSizes == '' &&
          productNamesForDeletedProducts == '') {
        context.read<CheckOutCubit>().getLocations().then((value) {
          context.read<AddToCartCubit>().setIsProceedButtonLoading = false;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FirstStep(
              locations: value,
            ),
          ));
        });
      } else if (productNamesForDeletedProducts != '') {
        showErrorMessage(
            "products (${productNamesForDeletedProducts.substring(0, productNamesForDeletedProducts.length - 1)}) is't available any more please delete them from your cart and try again",
            context);
      } else if (productNamesForColors == '' && productNamesForSizes != '') {
        showErrorMessage(
            "products (${productNamesForSizes.substring(0, productNamesForSizes.length - 1)}) doesn't have the sizes that you selected please select another sizes",
            context);
      } else if (productNamesForSizes == '' && productNamesForColors != '') {
        showErrorMessage(
            "products (${productNamesForColors.substring(0, productNamesForColors.length - 1)}) doesn't have the sizes that you selected please select another sizes",
            context);
      } else {
        showErrorMessage(
            "products (${productNamesForColors.substring(0, productNamesForColors.length - 1)}) doesn't have the color that you selected please select another colors, and products (${productNamesForSizes.substring(0, productNamesForSizes.length - 1)}) doesn't have the sizes that you selected please select another sizes",
            context);
      }
    }
  }

  showErrorMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Text(
                'Warning',
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              content: SizedBox(
                  height: message.length <= 140 ? 250.h : 380.h,
                  width: 600.w,
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                message,
                                style: const TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Okay",
                              style: TextStyle(fontSize: 20),
                            ))
                      ],
                    ),
                  )),
            ));
  }

  Future<dynamic> showMessage(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              content: SizedBox(
                  height: 250.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(fontSize: 25),
                        ),
                        SizedBox(height: 30.h),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Okay",
                              style: TextStyle(fontSize: 20),
                            ))
                      ],
                    ),
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, _) => Scaffold(
          // backgroundColor: Colors.white,
          body: Column(
            children: [
              const CustomAppBar(title: 'Shopping Bag'),
              Padding(
                padding: EdgeInsets.only(right: 25.w, left: 25.w, top: 7.h),
                child: const Divider(color: Color(0xFFC6C6C6), height: 0),
              ),
              context.watch<AddToCartCubit>().products.isEmpty
                  ? Expanded(
                      //! this padding to put the image and the text in the center
                      //! by looking at screen :)
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: ResizeImage(
                                const AssetImage(
                                    'assets/images/empty_cart.png'),
                                width: 150.w.toInt(),
                                height: 150.w.toInt(),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text('Your cart is empty',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'DM Sans',
                                    fontSize: 18.sp)),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Stack(
                        children: [
                          const ShoppingBagBody(),
                          Positioned(
                            bottom: 0,
                            child: CustomButton(
                              title:
                                  BlocBuilder<AddToCartCubit, AddToCartState>(
                                builder: (context, state) {
                                  return context
                                          .read<AddToCartCubit>()
                                          .getIsProceedButtonLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Proceed to checkout',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                },
                              ),
                              onPressed: () async {
                                bool key = false;
                                if (!context
                                    .read<AddToCartCubit>()
                                    .getIsProceedButtonLoading) {
                                  context
                                      .read<AddToCartCubit>()
                                      .setIsProceedButtonLoading = true;
                                  bool isConnected =
                                      await InternetInfo.isconnected();
                                  if (context.mounted) {
                                    if (isConnected) {
                                      var data = await sl
                                          .get<DataSource>()
                                          .updateDataBase();
                                      await sl
                                          .get<SharedPreferences>()
                                          .setString(
                                              'lastUpdate',
                                              DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString());
                                      if (context.mounted) {
                                        if (data['updatedProducts'] != null &&
                                            data['updatedProducts']!
                                                .isNotEmpty) {
                                          var d = data['updatedProducts']!;
                                          var oldProducts = context
                                              .read<AddToCartCubit>()
                                              .products;
                                          key = false;
                                          for (var i = 0;
                                              i < oldProducts.length;
                                              i++) {
                                            for (var element in d) {
                                              if (element.data['isAvailable']) {
                                                AddToCartProductModel
                                                    oldProduct =
                                                    AddToCartProductModel
                                                        .fromMap(
                                                            oldProducts[i]);
                                                ProductModel newProduct =
                                                    ProductModel.fromMap(
                                                        element.data);
                                                var newPrice = newProduct
                                                            .disCount >
                                                        0
                                                    ? (1 -
                                                            newProduct
                                                                    .disCount /
                                                                100) *
                                                        newProduct.price
                                                    : newProduct.price;
                                                if (oldProduct.price !=
                                                        newPrice &&
                                                    oldProduct.productName ==
                                                        newProduct.name) {
                                                  key = true;
                                                  context
                                                          .read<AddToCartCubit>()
                                                          .setIsProceedButtonLoading =
                                                      false;
                                                  showMessage(context,
                                                      'Some prices are changed please take a look at the new prices before continue');
                                                  break;
                                                }
                                              } else {
                                                // showMessage(context,
                                                //     'product ${element.data['name']} is done please deleted form you cart and try again');
                                                // key = true;
                                              }
                                            }
                                          }
                                          await context
                                              .read<AddToCartCubit>()
                                              .getAddToCartProducts();
                                          if (context.mounted) {
                                            context
                                                .read<AddToCartCubit>()
                                                .fetchData();
                                          }
                                          if (!key) {
                                            if (context.mounted) {
                                              goToNextPage(context);
                                            }
                                          }
                                          log('data updated');
                                        } else {
                                          goToNextPage(context);
                                        }
                                      }
                                    } else {
                                      context
                                          .read<AddToCartCubit>()
                                          .setIsProceedButtonLoading = false;
                                      ToastContext().init(context);
                                      Toast.show(
                                          'Check you internet connection');
                                    }
                                  }
                                }
                              },
                            ),
                          ),
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
