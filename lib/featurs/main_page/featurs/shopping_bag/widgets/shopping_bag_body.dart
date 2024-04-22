import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../products_view/models/add_to_cart_product_model.dart';
import '../cubits/item_product_cubit/item_product_cubit.dart';
import '../cubits/products_cubit/products_cubit.dart';
import 'info_card.dart';
import 'product_item.dart';

class ShoppingBagBody extends StatelessWidget {
  final AddToCartCubit addToCartCubit;
  const ShoppingBagBody({super.key, required this.addToCartCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SizedBox(
            //* I use this way because it is a Stack and
            //* with Stack can't use Expanded
            //* so I use SizedBox to fill the screen
            //*(screenSize - appBarSize)
            height: 852.h - 171.88616.h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 34.h),
                  BlocBuilder<AddToCartCubit, AddToCartState>(
                      builder: (context, state) => Column(
                            children: [
                              ...List.generate(
                                BlocProvider.of<AddToCartCubit>(context)
                                    .products
                                    .length,
                                (int index) {
                                  AddToCartProductModel product =
                                      AddToCartProductModel.fromMap(
                                          BlocProvider.of<AddToCartCubit>(
                                                  context)
                                              .products[index]);
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 28.h),
                                    child: Dismissible(
                                      onDismissed: (direction) {
                                        BlocProvider.of<AddToCartCubit>(context)
                                            .removeElement(product.id!);
                                        context
                                            .read<AddToCartCubit>()
                                            .getAddToCartProducts();
                                      },
                                      background: Container(
                                        padding: EdgeInsets.only(left: 19.65.w),
                                        alignment: Alignment.centerLeft,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        // margin: EdgeInsets.only(left: 7.6335.w),
                                        padding:
                                            EdgeInsets.only(right: 19.65.w),
                                        alignment: Alignment.centerRight,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      key:
                                          ValueKey<String>(product.productName),
                                      child: ProductItem(
                                          id: product.id!,
                                          imgUrl: product.imgUrl,
                                          title: product.productName,
                                          brand: product.companyMaker,
                                          color:
                                              Color(int.parse(product.color)),
                                          size: product.size,
                                          price: product.price,
                                          amountOfProduct: product.quantity),
                                      // child: BlocProvider.of<AddToCartCubit>(context)
                                      //     .products[index],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )),
                  SizedBox(height: 34.h),
                  BlocBuilder<AddToCartCubit, AddToCartState>(
                    builder: (context, state) {
                      return BlocBuilder<ItemProductCubit, ItemProductState>(
                        builder: (context, state) {
                          return InfoCard(
                              productPrice: addToCartCubit.totalPrice(),
                              shipping: 10);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
