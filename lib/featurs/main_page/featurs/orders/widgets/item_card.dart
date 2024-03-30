import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/cubit/orders_cubit.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/screen/rate_order.dart';

class ItemCard extends StatelessWidget {
  final int productId;
  final String url;
  final String title;
  final String type;
  final Color color;
  final String size;
  final int quantity;
  final double price;
  const ItemCard(
      {super.key,
      required this.productId,
      required this.url,
      required this.title,
      required this.type,
      required this.color,
      required this.size,
      required this.quantity,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(.1))
          ]),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color(0xFF9B9B9B).withOpacity(.4)),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: Image(
                    image: AssetImage(url),
                    fit: BoxFit.fill,
                    width: 60.w,
                  )),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Text(
                            '$price \$',
                            style: const TextStyle(
                              fontFamily: "DM Sans",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      type,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 10.sp,
                          color: const Color(0xFF9B9B9B)),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Color:  ',
                          style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 10.sp,
                              color: const Color(0xFF9B9B9B)),
                        ),
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: color),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.h),
                          height: 15.h,
                          width: 1,
                          color: const Color(0xFF9B9B9B),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size: $size',
                                style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontSize: 10.sp,
                                    color: const Color(0xFF9B9B9B)),
                              ),
                              Text(
                                "x $quantity  ",
                                style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontSize: 12.sp,
                                    color: const Color(0xFF9B9B9B)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            context.read<OrdersCubit>().opinionController =
                TextEditingController();
            context.read<OrdersCubit>().character = 50;
            context.read<OrdersCubit>().rating = 0;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RatePage(
                      ordersCubit: context.read<OrdersCubit>(),
                      productId: productId,
                    )));
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Text("Rate"),
          ),
        )
      ]),
    );
  }
}
