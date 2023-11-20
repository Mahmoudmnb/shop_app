import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/check_out_cubit.dart';

class PaymentMethodCard extends StatelessWidget {
  final String title;
  const PaymentMethodCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckOutCubit, CheckOutState>(
      listener: (context, state) {},
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
            padding:
                EdgeInsets.only(left: 10.w, top: 8.h, right: 20.w, bottom: 8.h),
            onPressed: () {
              cubit.changeAddress(title);
            },
            child: Row(
              children: [
                Radio(
                    activeColor: Colors.black,
                    value: title,
                    groupValue: cubit.selectPayment,
                    onChanged: (value) {
                      cubit.changePayment(value!);
                    }),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Sans'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
