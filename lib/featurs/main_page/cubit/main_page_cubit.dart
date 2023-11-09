import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
}
