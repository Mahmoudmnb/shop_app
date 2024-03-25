import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/auth/blocs/auth_blocs.dart';

class AuthCustomButton extends StatelessWidget {
  const AuthCustomButton(
      {super.key, required this.text, required this.onPressed});
  final Widget text;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInLoadingBloc, SignInLoadingState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Constant.duration,
          width: state is IsLoading
              ? state.isLoading
                  ? 90.h
                  : 156.w
              : 156.w,
          height: 51.h,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF252525),
              ),
              child: text,
              onPressed: state is IsLoading
                  ? state.isLoading
                      ? null
                      : state is IsSkipButtonLoading
                          ? state.isLoading
                              ? null
                              : onPressed
                          : onPressed
                  : state is IsSkipButtonLoading
                      ? state.isLoading
                          ? null
                          : onPressed
                      : onPressed),
        );
      },
    );
  }
}
