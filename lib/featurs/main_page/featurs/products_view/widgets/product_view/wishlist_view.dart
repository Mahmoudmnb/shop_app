import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/injection.dart';

import '../../../../data_source/data_source.dart';
import '../../../home/models/product_model.dart';
import '../../cubits/product_screen/cubit.dart';
import 'wishlist_border.dart';

class WishListView extends StatelessWidget {
  final List<Map<String, dynamic>> borders;
  final ProductModel product;
  final TextEditingController borderNameCon;
  final GlobalKey<FormState> fromKey;
  final BuildContext ctx;
  const WishListView(
      {super.key,
      required this.ctx,
      required this.borders,
      required this.product,
      required this.fromKey,
      required this.borderNameCon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 513.h,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFDFDFDF),
            ),
            width: 70.w,
            height: 4.5.h,
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            child: SizedBox(
              height: 60.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Image(
                      image: AssetImage(product.imgUrl.split('|')[0]),
                      fit: BoxFit.cover,
                      width: 60.w,
                      height: 60.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      const Text(
                        'Added To Wishlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.06,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      BlocBuilder<ProductCubit, ProductStates>(
                        builder: (context, state) {
                          return Text(
                            context.read<ProductCubit>().selectedBorder,
                            style: const TextStyle(
                              color: Color(0xFFEEEEEE),
                              fontSize: 10,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.06,
                              letterSpacing: 1,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Spacer(),
                      Icon(
                        Icons.favorite,
                        color: const Color(0xFFF8F7F7),
                        size: 30.sp,
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: Container(
              color: const Color(0xFF383838),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 22.w),
                    child: Column(
                      children: [
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Borders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 1.06,
                                letterSpacing: 1,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide.none,
                                    ),
                                    backgroundColor: const Color(0xFF383838),
                                    title: SizedBox(
                                      width: 300.w,
                                      child: const Center(
                                          child: Text(
                                        'Border Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'DM Sans',
                                          fontWeight: FontWeight.w400,
                                          height: 1.06,
                                          letterSpacing: 1,
                                        ),
                                      )),
                                    ),
                                    content: Form(
                                      key: fromKey,
                                      child: TextFormField(
                                        maxLength: 50,
                                        controller: borderNameCon,
                                        onEditingComplete: () async {
                                          List<Map<String, dynamic>> borders =
                                              await sl
                                                  .get<DataSource>()
                                                  .getBorderByName(borderNameCon
                                                      .text
                                                      .trim());
                                          if (context.mounted) {
                                            context
                                                    .read<ProductCubit>()
                                                    .isBorderNameIsAvailable =
                                                borders.isEmpty;
                                          }
                                          if (fromKey.currentState!
                                              .validate()) {
                                            await sl
                                                .get<DataSource>()
                                                .addBorder(
                                                    borderNameCon.text.trim());
                                            borders = await sl
                                                .get<DataSource>()
                                                .getBorders();
                                            if (context.mounted) {
                                              context
                                                      .read<ProductCubit>()
                                                      .selectedBorder =
                                                  borderNameCon.text.trim();
                                              context
                                                      .read<ProductCubit>()
                                                      .selectedBorderIndex =
                                                  borders.length - 1;
                                              Navigator.of(context).pop();
                                              context
                                                  .read<ProductCubit>()
                                                  .updateBordersList();
                                            }
                                          }
                                        },
                                        validator: (value) {
                                          if (!context
                                              .read<ProductCubit>()
                                              .isBorderNameIsAvailable) {
                                            return 'border name should be uniqe';
                                          } else if (value == null ||
                                              value.length < 3) {
                                            return 'border name should be more than three charcters';
                                          }
                                          return null;
                                        },
                                        cursorColor: Colors.grey,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'DM Sans',
                                          letterSpacing: 1,
                                        ),
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFF5A5A5A),
                                          hintText: 'Border Name',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: const Color(0xFF689FD1),
                              ),
                              child: const Text(
                                'New Border',
                                style: TextStyle(
                                  color: Color(0xFF689FD1),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 1.06,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<ProductCubit, ProductStates>(
                          builder: (context, state) {
                            return FutureBuilder(
                              future: sl.get<DataSource>().getBorders(),
                              builder: (_, snapshoot) {
                                List<Map<String, dynamic>> data = [];
                                if (snapshoot.hasData) {
                                  data = snapshoot.data!;
                                } else {
                                  data = borders;
                                }
                                return Column(
                                  //! here is the list of borders
                                  children: List.generate(
                                    data.length,
                                    (index) {
                                      return FutureBuilder(
                                          future: sl
                                              .get<DataSource>()
                                              .getProductsInBorder(
                                                  data[index]['id']),
                                          builder: (_, snapshoot) {
                                            return !snapshoot.hasData
                                                ? const SizedBox.shrink()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.w,
                                                        right: 22.w,
                                                        bottom: 15.h),
                                                    child: WishlistBorder(
                                                      countOfProductInThisBorder:
                                                          snapshoot
                                                              .data!.length,
                                                      onTap: () async {
                                                        var newBorders = await sl
                                                            .get<DataSource>()
                                                            .getBorders();
                                                        if (context.mounted) {
                                                          context
                                                              .read<
                                                                  ProductCubit>()
                                                              .selectedBorderIndex = index;
                                                          context
                                                              .read<
                                                                  ProductCubit>()
                                                              .changeSelectedBorderName(
                                                                  newBorders[
                                                                          index]
                                                                      [
                                                                      'borderName']);
                                                        }
                                                      },
                                                      border: data[index],
                                                      product: product,
                                                    ),
                                                  );
                                          });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // ListView(shrinkWrap: true,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
