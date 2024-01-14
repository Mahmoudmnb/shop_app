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
        builder: (_) => AlertDialog(
              actions: [
                MaterialButton(
                  child: Text(
                    'Register now',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AuthPage()));
                  },
                ),
                MaterialButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
              title: Text(
                'You have to register before you can get here !',
                style: TextStyle(fontSize: 20.sp),
              ),
            ));
  }
}
