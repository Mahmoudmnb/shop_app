import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  String selectAddress = '1';
  changeAddress(String address) {
    selectAddress = address;
    print(selectAddress);
    emit(ChangeAddressState());
  }
}
