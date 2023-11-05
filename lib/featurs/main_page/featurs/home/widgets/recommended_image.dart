import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendedImage extends StatelessWidget {
  final String productNamge;
  final String productPrice;
  final String imageUrl;
  final String companyMaker;
  const RecommendedImage(
      {super.key,
      required this.companyMaker,
      required this.imageUrl,
      required this.productNamge,
      required this.productPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0xffF1F1F1),
          borderRadius: BorderRadius.circular(15)),
      height: 68.h,
      width: 257.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
              height: 68.h,
              width: 70.w,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyMaker,
                style: TextStyle(fontSize: 16.sp, fontFamily: 'Tenor Sans'),
              ),
              Text(productNamge,
                  style: TextStyle(
                      fontFamily: 'Tenor Sans',
                      fontSize: 13.sp,
                      color: const Color(0xff929292))),
              Text(productPrice,
                  style: TextStyle(
                      fontFamily: 'Tenor Sans',
                      fontSize: 11.sp,
                      color: const Color(0xff6D6D6D)))
            ],
          )
        ],
      ),
    );
  }
}
