import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/injection.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  String selectAddress = '1';
  String? profileImagePath = '';
  changeAddress(String address) {
    selectAddress = address;
    log(selectAddress);
    emit(ChangeAddressState());
  }

  void changeProfileImagePath(String path) {
    profileImagePath = path;
    emit(ChangeProfileImagePath());
  }

  updateProfileImageWidget() {
    emit(ProfileInitial());
  }

  changePassword(String newPassword) async {
    sl.get<DataSource>().changePassword(newPassword);
  }
}
