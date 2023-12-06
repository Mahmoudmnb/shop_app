import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/check_out_cubit.dart';

class CheckOutMethodCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  const CheckOutMethodCard(
      {super.key,
      required this.title,
      required this.description,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckOutCubit, CheckOutState>(
      builder: (context, state) {
        CheckOutCubit cubit = CheckOutCubit.get(context);
        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.04))
          ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: MaterialButton(
            padding: EdgeInsets.only(
                left: 10.w, top: 8.h, right: 20.w, bottom: 16.h),
            onPressed: () {
              cubit.changeMethod(title);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        value: title,
                        groupValue: cubit.selectMethod,
                        onChanged: (value) {
                          cubit.changeMethod(value!);
                        }),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans'),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Tenor Sans',
                          color: const Color(0xFFD57676)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF828282),
                          fontFamily: 'Tenor Sans'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
