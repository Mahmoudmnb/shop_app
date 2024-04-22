import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/models/product_model.dart';

class CustomCard extends StatelessWidget {
  final double width;
  final double height;
  final ProductModel product;
  const CustomCard(
      {super.key,
      required this.width,
      required this.height,
      required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Image(
              image: ResizeImage(
                AssetImage(product.imgUrl.split('|')[0]),
                height: height.toInt(), //- 6.h,
                width: width.toInt(),
              ),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 5),
              child: SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // width: 90.w,
                          child: Text(
                            product.name,
                            style: TextStyle(
                              color: const Color(0xFF383838),
                              fontSize: 14.sp,
                              fontFamily: 'Tenor Sans',
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400,
                              height: 1.06,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Text(
                          '${product.price} \$',
                          style: TextStyle(
                            color: const Color(0xFFD47676),
                            fontSize: 10.sp,
                            fontFamily: 'Tenor Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.06,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          product.makerCompany,
                          style: TextStyle(
                            color: const Color(0xFF818181),
                            fontSize: 11.sp,
                            fontFamily: 'Tenor Sans',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            height: 1.06,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
