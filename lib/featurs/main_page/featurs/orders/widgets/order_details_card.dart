import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCard extends StatelessWidget {
  final String orderNumber;
  final String trackingNumber;
  final String deliberyAddress;
  final String shoppingMethod;

  const OrderDetailsCard(
      {super.key,
      required this.orderNumber,
      required this.trackingNumber,
      required this.deliberyAddress,
      required this.shoppingMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.25))
          ],
          color: Colors.white,
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Order number",
              style: TextStyle(
                fontFamily: 'Tenor Sans',
                color: Color(0xFF828282),
              ),
            ),
            Text("#$orderNumber"),
          ]),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tracking number",
                style: TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: Color(0xFF828282),
                ),
              ),
              Text(trackingNumber),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Delivery address",
                style: TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: Color(0xFF828282),
                ),
              ),
              Text(deliberyAddress),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shopping method",
                style: TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: Color(0xFF828282),
                ),
              ),
              Text(shoppingMethod),
            ],
          ),
          SizedBox(height: 10.h),
        ]));
  }
}
