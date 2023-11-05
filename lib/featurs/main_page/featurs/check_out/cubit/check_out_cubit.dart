import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());
  static CheckOutCubit get(context) => BlocProvider.of(context);
  String selectAddress = 'My Home';
  String selectMethod = 'In store pick-up';
  String selectPayment = 'Credit Card';
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
}
