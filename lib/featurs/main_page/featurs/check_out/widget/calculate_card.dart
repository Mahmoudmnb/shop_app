import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculateCard extends StatelessWidget {
  final double productPrice;
  final double deliveryCost;
  const CalculateCard(
      {super.key, required this.productPrice, required this.deliveryCost});

  @override
  Widget build(BuildContext context) {
    log(productPrice.toString());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, -5),
                blurRadius: 11,
                color: Colors.black.withOpacity(.04))
          ]),
      child: Column(children: [
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 40.w),
              const Text(
                "Product Price",
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              Text('\$$productPrice'),
              SizedBox(width: 40.w),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE8E8E8)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 40.w),
              const Text(
                "Shopping",
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              const Text('\$10'),
              SizedBox(width: 40.w),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE8E8E8)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 40.w),
              const Text(
                "delivary cost",
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const Spacer(),
              Text('\$${(deliveryCost - 10).toStringAsFixed(2)}'),
              SizedBox(width: 40.w),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE8E8E8)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 40.w),
              const Text(
                "Subtotal",
                style: TextStyle(fontFamily: 'DM Sans'),
              ),
              const Spacer(),
              Text('\$${(productPrice + deliveryCost).toStringAsFixed(2)}'),
              SizedBox(width: 40.w),
            ],
          ),
        ),
      ]),
    );
  }
}
