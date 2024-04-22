import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendyImage extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String productName;
  final String makerCompany;
  const TrendyImage({
    Key? key,
    required this.makerCompany,
    required this.imageUrl,
    required this.price,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 108.w,
          height: 131.h,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fill,
              //! maybe the image isn't واضحة but this the solution
              image: ResizeImage(
                width: 100.w.toInt(),
                AssetImage(imageUrl.split('|')[0]),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 110.w,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ' $makerCompany',
                  style: TextStyle(
                      fontFamily: 'DM Sans',
                      color: const Color(0xff393939),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  '$price\$',
                  style: TextStyle(
                      fontFamily: 'DM Sans',
                      color: const Color(0xffD57676),
                      fontSize: 10.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: Text(
            ' $productName',
            style: TextStyle(
                fontFamily: 'DM Sans',
                color: const Color(0xff828282),
                fontSize: 11.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
