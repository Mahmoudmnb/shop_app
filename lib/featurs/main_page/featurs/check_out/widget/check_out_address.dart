import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/check_out_cubit.dart';

class CheckOutAddressCard extends StatelessWidget {
  final String title;
  final String description;
  final int lengthOfLocations;
  const CheckOutAddressCard({
    super.key,
    required this.title,
    required this.description,
    required this.lengthOfLocations,
  });

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
            padding: EdgeInsets.only(left: 10.w, right: 20.w, bottom: 16.h),
            onPressed: () {
              cubit.changeAddress(title);
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Radio(
                      activeColor: Colors.black,
                      //! this condition if you have one location selected by default
                      //! this is wrong way
                      value: lengthOfLocations==1 ? cubit.selectAddress : title,
                      groupValue: cubit.selectAddress,
                      onChanged: (value) {
                        cubit.changeAddress(value!);
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans'),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                          color: Color(0xFF828282), fontFamily: 'Tenor Sans'),
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
