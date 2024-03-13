import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/injection.dart';

import '../../../data_source/data_source.dart';
import '../models/address_model.dart';

part 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());
  static CheckOutCubit get(context) => BlocProvider.of(context);
  bool isLoading = false;
  String selectAddress = '';
  String selectMethod = 'In store pick-up';
  String selectPayment = 'Paypal';
  changeAddress(String address) {
    selectAddress = address;
    emit(ChangeAddressState());
  }

  changePayment(String pay) {
    selectPayment = pay;
    emit(ChangePayState());
  }

  changeIsLoading(value) {
    isLoading = value;
    emit(IsLoadingState());
  }

  changeMethod(String method) {
    selectMethod = method;
    emit(ChangeMethodState());
  }

  bool agree = false;
  changeAgree(bool x) {
    agree = x;
    emit(ChangeAgreeState());
  }

//! mnb
  String selectedCountryCode = '+963';
  Future<void> addNewAdress(AddressModel address) async {
    await sl.get<DataSource>().addNewLocation(address);
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    return sl.get<DataSource>().getLocations();
  }

  Future<List<Map<String, dynamic>>> getLocationByName(
      String addressName) async {
    return sl.get<DataSource>().getLocationByName(addressName);
  }

  List<Map<String, dynamic>> locations = [];
  bool isDelfaultLocatoin = false;
  bool isAddressNameIsAvailable = true;
  void changeIsDelfaultLocatoin(bool value) {
    isDelfaultLocatoin = value;
    emit(IsDefaultLoacatoinState());
  }

  void changeSelectedCountryCode(value) {
    selectedCountryCode = value;
    emit(ChangeSelectedCountryCode());
  }

  bool _isUpdateAddLocationButtonLoading = false;
  set setIsUpdateAddLocationButtonLoading(value) {
    _isUpdateAddLocationButtonLoading = value;
    emit(IsUpdateAddLocationButtonLoading());

  }

  get getIsUpdateAddLocationButtonLoading => _isUpdateAddLocationButtonLoading;

}
