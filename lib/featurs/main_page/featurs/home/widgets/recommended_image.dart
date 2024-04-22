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
            child: Image(
              image: ResizeImage(AssetImage(imageUrl),
                  height: 68.h.toInt(), width: 70.w.toInt()),
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyMaker,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Tenor Sans',
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Text(productNamge,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'Tenor Sans',
                          fontSize: 12.sp,
                          color: const Color(0xff929292))),
                ),
                Text(productPrice,
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        fontSize: 11.sp,
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff6D6D6D)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
