
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'info_card_view.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.productPrice,
    required this.shipping,
  });
  final double productPrice;
  final double shipping;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.55.w, vertical: 40.h),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(
              width: 1,
              color: Color(0xFFDBDBDB),
            ),
          ),
        ),
        child: InfoCardView(productPrice: productPrice, shipping: shipping));
  }
}
