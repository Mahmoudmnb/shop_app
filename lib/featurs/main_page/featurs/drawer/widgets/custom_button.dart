import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/auth/pages/auth_page.dart';
import 'package:toast/toast.dart';

import '../../../../../core/constant.dart';
import '../../../../../core/internet_info.dart';
import '../../profile/cubit/profile_cubit.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393.w,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: const Color(0xFFD47676),
          backgroundColor: const Color(0xAAECECEC),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: () {
          if (Constant.currentUser != null) {
            if (!context.read<ProfileCubit>().isLogOutLoading) {
              context.read<ProfileCubit>().setIsLogOutLoading(true);
              InternetInfo.isconnected().then((value) async {
                if (value) {
                  await context.read<ProfileCubit>().logOut();
                  if (context.mounted) {
                    context.read<ProfileCubit>().setIsLogOutLoading(false);
                    Constant.currentUser = null;
                  }
                } else {
                  context.read<ProfileCubit>().setIsLogOutLoading(false);
                  ToastContext().init(context);
                  Toast.show('Check your internet connection',
                      duration: Toast.lengthLong);
                }
              });
            }
          } else {
            Scaffold.of(context).closeDrawer();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const AuthPage()));
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return context.read<ProfileCubit>().isLogOutLoading
                ? SizedBox(
                  height: 30.h,
                  child: const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                )
                : Text(
                    Constant.currentUser == null ? 'Log in' : 'Log out',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: const Color(0xFFD47676),
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.08,
                      letterSpacing: 0.72,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
