import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  String selectAddress = '1';
  changeAddress(String address) {
    selectAddress = address;
    log(selectAddress);
    emit(ChangeAddressState());
  }
}
