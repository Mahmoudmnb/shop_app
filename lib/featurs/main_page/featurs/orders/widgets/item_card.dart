import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemCard extends StatelessWidget {
  final String url;
  final String title;
  final String type;
  final Color color;
  final String size;
  final int quantity;
  final double price;
  const ItemCard(
      {super.key,
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
                child: Image.asset(
                  url,
                  fit: BoxFit.fill,
                  width: 60.w,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Flydat shirt',
                          textAlign: TextAlign.start,
                          style: TextStyle(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Size: $size',
                              style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 10.sp,
                                  color: const Color(0xFF9B9B9B)),
                            ),
                            SizedBox(width: 160.w),
                            Text(
                              "x $quantity",
                              style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 12.sp,
                                  color: const Color(0xFF9B9B9B)),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: const Text("Rate"),
        )
      ]),
    );
  }
}
