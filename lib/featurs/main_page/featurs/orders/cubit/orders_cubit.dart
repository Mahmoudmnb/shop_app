import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
  static OrdersCubit get(context) => BlocProvider.of(context);
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

  String kindOfOrder = 'Pending';
  numofcharcters() {
    character = 50 - opinionController.text.length;
    emit(ChanegNumOfCharacterState());
  }

  changeKingOfOrder(String kind) {
    kindOfOrder = kind;
    emit(ChangKindOfOrderState());
  }
}
