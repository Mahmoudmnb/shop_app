import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial());
  static WishlistCubit get(context) => BlocProvider.of(context);
  TextEditingController opinionController = TextEditingController();
  int character = 50;
  double rating = 0;
  bool isLoading = false;
  void changeIsLoading(value) {
    isLoading = value;
    emit(IsLoading());
  }

  void changeRating(double value) {
    rating = value;
    emit(ChangeRating());
  }

  String kindOfOrder = 'Borders';
  numofcharcters() {
    character = 50 - opinionController.text.length;
    emit(ChanegNumOfCharacterState());
  }

  changeKingOfOrder(String kind) {
    kindOfOrder = kind;
    emit(ChangKindOfOrderState());
  }
}
