import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/injection.dart';

import '../../../../data_source/data_source.dart';

part 'item_product_state.dart';

class ItemProductCubit extends Cubit<ItemProductState> {
  ItemProductCubit() : super(ItemProductInitial());
  void addAmount(int id, int quantity) async {
    log('addAmount');
    if (quantity < 100) {
      quantity++;
      sl.get<DataSource>().updateQuantity(id, quantity);
      Map<String, dynamic> data =
          await sl.get<DataSource>().getAddToCartProductById(id);
      Map<String, int> dataa = {'quantity': data['quantity'], 'id': id};
      emit(ItemProductChanged(product: dataa));
    }
  }

  void removeAmount(int id, int quantity) async {
    log('removeAmount');
    if (quantity > 1) {
      quantity--;
      sl.get<DataSource>().updateQuantity(id, quantity);
      Map<String, dynamic> data =
          await sl.get<DataSource>().getAddToCartProductById(id);
      Map<String, int> dataa = {
        'quantity': data['quantity'],
        'id': id
      };
      emit(ItemProductChanged(product: dataa));
    }
  }
}
