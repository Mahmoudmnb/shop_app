import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckOutList extends StatelessWidget {
  const CheckOutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      // height: 400.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(.1))
          ]),
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Flyday shirt",
                      style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: Color(0xFF393939),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('x 1'),
                        SizedBox(width: 30.w),
                        const Text('25 \$'),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 50.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub Total",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('25 \$')
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deliver",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('4.99 \$')
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('29.99 \$')
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }
}
