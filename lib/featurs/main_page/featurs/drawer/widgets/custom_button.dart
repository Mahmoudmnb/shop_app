import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/featurs/auth/pages/auth_page.dart';
import 'package:toast/toast.dart';

import '../../../../../core/constant.dart';
import '../../../../../core/internet_info.dart';
import '../../profile/cubit/profile_cubit.dart';
import '../cubit/drawer_cubit.dart';

class CustomButton extends StatelessWidget {
  final ProfileCubit profileCubit;
  final DrawerCubit drawerCubit;
  const CustomButton(
      {super.key, required this.profileCubit, required this.drawerCubit});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
        onPressed: () async {
          if (Constant.currentUser != null) {
            if (!profileCubit.isLogOutLoading) {
              profileCubit.setIsLogOutLoading(true);
              bool isConnected = await InternetInfo.isconnected();
              if (isConnected) {
                XFile? image;
                if (Constant.currentUser!.imgUrl != null) {
                  image == XFile(Constant.currentUser!.imgUrl!);
                } else {
                  image = null;
                }
                if (!await profileCubit.logOut(image)) {
                  if (context.mounted) {
                    Toast.show('Something went wrong please try again',
                        duration: Toast.lengthLong);
                  }
                } else {
                  if (context.mounted) {
                    profileCubit.setIsLogOutLoading(false);
                    Constant.currentUser = null;
                    drawerCubit.refreshDrawer();
                  }
                }
              } else {
                profileCubit.setIsLogOutLoading(false);
                if (context.mounted) {
                  Toast.show('Check your internet connection',
                      duration: Toast.lengthLong);
                }
              }
            }
          } else {
            Scaffold.of(context).closeDrawer();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AuthPage(
                      fromPage: 'Profile',
                    )));
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return profileCubit.isLogOutLoading
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
