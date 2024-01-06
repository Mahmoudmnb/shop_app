import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'price_info.dart';

class InfoCardView extends StatelessWidget {
  const InfoCardView({
    super.key,
    required this.productPrice,
    required this.shipping,
  });
  final double productPrice;
  final double shipping;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceInfo(
          title: 'Product Price',
          //! this edit for showing 2 numbers after the point just
          price: '\$${productPrice.toStringAsFixed(2)}',
          color: const Color(0xFFAAAAAA),
        ),
        SizedBox(height: 10.h),
        const Divider(color: Color(0xFFE8E8E8)),
        SizedBox(height: 10.h),
        PriceInfo(
          title: 'Shipping',
          price: '\$${shipping.toStringAsFixed(2)}',
          color: const Color(0xFFAAAAAA),
        ),
        SizedBox(height: 10.h),
        const Divider(color: Color(0xFFE8E8E8)),
        SizedBox(height: 10.h),
        PriceInfo(
          title: 'Subtotal',
          price: '\$${(productPrice + shipping).toStringAsFixed(2)}',
        ),
      ],
    );
  }
}
