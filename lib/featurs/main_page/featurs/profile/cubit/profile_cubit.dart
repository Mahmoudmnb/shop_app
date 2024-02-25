import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/injection.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  String selectAddress = '1';
  String? profileImagePath = '';
  bool isLogOutLoading = false;
  changeAddress(String address) {
    selectAddress = address;
    log(selectAddress);
    emit(ChangeAddressState());
  }

  setIsLogOutLoading(value) {
    isLogOutLoading = value;
    emit(ChangeIsLogOutLoading());
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

  Future<void> logOut() async {
    var cartProducts = await sl.get<DataSource>().getAddToCartProducts();
    var borders = await sl.get<DataSource>().getBorders();
    var borderProducts = await sl.get<DataSource>().getAllBorderProducts();
      String bor = '';
      String proBor = '';
      String cartPro = '';
      for (var element in borders) {
        bor += '${jsonEncode(element)}|';
      }
      for (var element in borderProducts) {
        proBor += '${jsonEncode(element)}|';
      }
      for (var element in cartProducts) {
        cartPro += '${jsonEncode(element)}|';
      }

      cartPro = cartPro.isEmpty ? '' : cartPro.substring(0, cartPro.length - 1);
      bor = bor.isEmpty ? '' : bor.substring(0, bor.length - 1);
      proBor = proBor.isEmpty ? '' : proBor.substring(0, proBor.length - 1);
      await sl.get<DataSource>().uploadProfileSettings(proBor, cartPro, bor);
      await sl.get<SharedPreferences>().remove('currentUser');
  }
}
