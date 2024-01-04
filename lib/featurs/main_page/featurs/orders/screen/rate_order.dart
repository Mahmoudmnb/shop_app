import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

import '../cubit/orders_cubit.dart';
import '../widgets/build_back_arrow.dart';

class RateOrder extends StatelessWidget {
  const RateOrder({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        var cubit = OrdersCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        const buildBackArrow(),
                        SizedBox(width: 20.w),
                        Text(
                          'feedback',
                          style: TextStyle(
                              fontFamily: 'Tenor Sans',
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
                      width: double.infinity,
                      child: Text(
                        "Share your opinion in the order",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: 'Tenor Sans',
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF393939)),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10.w),
                      child: const Text('How much do you rate order?',
                          style: TextStyle(
                              color: Color(0xFF6D6D6D),
                              fontFamily: 'Tenor Sans')),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        RatingStars(rating: 2, editable: true),
                        const Spacer()
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(.15))
                          ]),
                      child: Column(
                        children: [
                          TextField(
                            maxLength: 50,
                            onChanged: (value) {
                              cubit.numofcharcters();
                            },
                            controller: cubit.OpinionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                                counter: Container(),
                                hintText:
                                    'Would you like to write anything about this order?',
                                hintStyle: const TextStyle(
                                    color: Color(0XFF919191),
                                    fontFamily: 'Tenor Sans'),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10.w),
                            width: double.infinity,
                            child: Text(
                              '${cubit.character} characters',
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: Color(0xFF919191)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10.w),
                      child: const Text('Add a picture for your order',
                          style: TextStyle(
                              color: Color(0xFF6D6D6D),
                              fontFamily: 'Tenor Sans')),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SizedBox(width: 20.w),
                        SizedBox(
                            height: 70.h,
                            child: const Image(
                                image: AssetImage('assets/icons/galary.png'))),
                        SizedBox(width: 20.w),
                        SizedBox(
                            height: 70.h,
                            child: const Image(
                                image: AssetImage('assets/icons/camera.png')))
                      ],
                    ),
                    SizedBox(height: 95.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {},
                        child: Ink(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Send feedback",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "DM Sans"),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
