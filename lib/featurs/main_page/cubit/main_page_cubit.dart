import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/auth/pages/auth_pages.dart';

part 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitial());
  int pageIndex = 0;
  void changePageIndex(int value) {
    pageIndex = value;
    emit(PageIndex());
  }

  bool isAddLocationLoading = false;
  void changeIsAddLocationLoading(bool value) {
    isAddLocationLoading = value;
    emit(AddLocationLoading());
  }

  void updateProfilePageData() {
    emit(UpdateProfilePage());
  }

  void showRegisterMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              content: SizedBox(
                  height: 230.h,
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        "You have to resigister",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'DM Sans',
                            color: Colors.grey[1000]),
                      ),
                      SizedBox(height: 30.h),
                      Image(
                          height: 100.h,
                          color: Colors.grey[600],
                          image: const AssetImage(
                            'assets/icons/needsign.png',
                          )),
                      Row(
                        children: [
                          const Spacer(),
                          MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const AuthPage()));
                              },
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: 'DM Sans',
                                    color: Colors.grey[1000]),
                              ))
                        ],
                      )
                    ],
                  )),
            ));
  }
}
