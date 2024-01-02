import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';

import '../model/order_model.dart';
import '../screen/order_details.dart';

class BuildOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDeliverd;
  const BuildOrderCard(
      {super.key, required this.order, required this.isDeliverd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 24,
                color: Colors.black.withOpacity(.09))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Order #${order.orderId}",
          style: TextStyle(
              fontFamily: "DM Sans",
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 4)
              ]),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              // flex: 6,
              child: Row(
                children: [
                  Text(
                    "Order date",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: const Color(0xFF828282),
                        fontSize: 13.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${Constant.stringToDate(order.createdAt).day}/${Constant.stringToDate(order.createdAt).month}/${Constant.stringToDate(order.createdAt).year}",
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              // flex: 4,
              child: Row(
                children: [
                  Text(
                    "due date",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: const Color(0xFF828282),
                        fontSize: 13.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    order.shoppingMethod == 'In store pick-up'
                        ? 'In store'
                        : "${Constant.stringToDate(order.createdAt).add(Duration(days: order.shoppingMethod == 'Express delivery' ? 1 : 3)).day}/${Constant.stringToDate(order.createdAt).add(const Duration(days: 3)).month}/${Constant.stringToDate(order.createdAt).add(const Duration(days: 3)).year}",
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // flex: 6,
              child: Row(
                children: [
                  const Text(
                    "Quantity:",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${order.ordersIds.split('|').length}",
                    style: const TextStyle(
                        fontFamily: 'Tenor Sans', color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              // flex: 4,
              child: Row(
                children: [
                  const Text(
                    "Total price",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${order.totalPrice.toStringAsFixed(2)}\$",
                    style: const TextStyle(
                        fontFamily: 'Tenor Sans', color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            const Text(
              "Tracking number:",
              style:
                  TextStyle(fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
            ),
            SizedBox(width: 8.w),
            Text(
              order.trackingNumber,
              style: const TextStyle(
                  fontFamily: 'Tenor Sans', color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isDeliverd ? 'Deliverd' : 'Pending',
              style: TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: !isDeliverd
                      ? const Color(0xFFD57676)
                      : const Color(0xFF76D5AD),
                  fontSize: 15.sp),
            ),
            GestureDetector(
              onTap: () {
                List<String> amounts =
                    Constant.stringToList(order.amounts) as List<String>;
                List<String> colors =
                    Constant.stringToList(order.colors) as List<String>;
                List<String> sizes =
                    Constant.stringToList(order.sizes) as List<String>;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderDetails(
                    order: order,
                    isDeliverd: isDeliverd,
                    sizes: sizes,
                    colors: colors,
                    amounts: amounts,
                  ),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(.25))
                    ],
                    border: Border.all(color: const Color(0xFF434343))),
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
