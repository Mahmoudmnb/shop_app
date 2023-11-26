import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/injection.dart';

import '../../../data_source/data_source.dart';
import '../models/address_model.dart';

part 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());
  static CheckOutCubit get(context) => BlocProvider.of(context);
  String selectAddress = 'work';
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
  Future<void> addNewAdress(AddressModel address) async {
    await sl.get<DataSource>().addNewLocation(address);
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    return sl.get<DataSource>().getLocations();
  }

  List<Map<String, dynamic>> locations = [];
}
