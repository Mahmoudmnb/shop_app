import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constant.dart';
import '../../../../../injection.dart';
import '../../../data_source/data_source.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  String selectAddress = '1';
  String? profileImagePath = '';
  bool isLogOutLoading = false;
  bool isSaveButtonLoading = false;
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

  Future<bool> changePassword(String newPassword) async {
    return sl.get<DataSource>().changePassword(newPassword);
  }

  changeIsSaveButtonLoading(bool value) {
    isSaveButtonLoading = value;
    emit(ChangeIsSaveLoading());
  }

  Future<bool> logOut(XFile? image) async {
    var cartProducts = [];
    var res = await sl.get<DataSource>().getAddToCartProducts();
    var s = res.fold((l) {
      cartProducts = l;
      return true;
    }, (r) => false);
    if (!s) {
      return false;
    }
    var borders = [];
    var res1 = await sl.get<DataSource>().getBorders();
    var s1 = res1.fold((l) {
      borders = l;
      return true;
    }, (r) => false);
    if (!s1) {
      return false;
    }

    var borderProducts = [];
    var res2 = await sl.get<DataSource>().getAllBorderProducts();
    var s3 = res2.fold((l) {
      borderProducts = l;
      return true;
    }, (r) => false);
    if (!s3) {
      return false;
    }

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
    if (image != null) {
      if (!await sl.get<DataSource>().uploadImage(image)) {
        return false;
      }
      await File('${Constant.baseUrl}profileImage.jpg').delete();
    }
    var isSuccess =
        await sl.get<DataSource>().uploadProfileSettings(proBor, cartPro, bor);
    if (!isSuccess) {
      return false;
    }
    await sl.get<SharedPreferences>().remove('currentUser');
    await sl.get<SharedPreferences>().remove('defaultLocation');
    await sl.get<DataSource>().clearAddToCartTable();
    await sl.get<DataSource>().clearBordersTable();
    await sl.get<DataSource>().clearBorderProductsTable();
    await sl.get<DataSource>().clearOrdersTable();
    await sl.get<DataSource>().clearLocationsTable();
    return true;
  }
}
