import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({
    super.key,
    required this.title,
    required this.price,
    this.color = Colors.black,
  });
  final String title;
  final Color color;
  final String price;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: 'DM Sans',
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
