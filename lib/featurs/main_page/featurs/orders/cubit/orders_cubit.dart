import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
  static OrdersCubit get(context) => BlocProvider.of(context);
  TextEditingController OpinionController = TextEditingController();
  int character = 50;
  String kindOfOrder = 'Pending';
  numofcharcters() {
    character = 50 - OpinionController.text.length;
    emit(ChanegNumOfCharacterState());
  }

  changeKingOfOrder(String kind) {
    kindOfOrder = kind;
    emit(ChangKindOfOrderState());
  }
}
