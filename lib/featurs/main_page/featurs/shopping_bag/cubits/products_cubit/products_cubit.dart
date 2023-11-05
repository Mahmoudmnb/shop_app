import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_source/data_source.dart';
import '../../../../../../injection.dart';

part 'products_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(ProductsInitial());

  List<Map<String, dynamic>> products = [];
  void removeElement(int id) {
    sl
        .get<DataSource>()
        .removeItemFromAddToCartProducts(id)
        .then((value) async {
      products = await sl.get<DataSource>().getAddToCartProducts();
      emit(ProductsRemoveElement());
    });
  }

  void addElement(Map<String, dynamic> item) {
    products.add(item);
    emit(ProductsAddElement());
  }

  void fetchData() {
    emit(ProductsFetchData());
  }

  double totalPrice() {
    double total = 0;
    for (var element in products) {
      total += element['price'] * element['quantity'];
    }
    return total;
  }

  void getAddToCartProducts() async {
    products = await sl.get<DataSource>().getAddToCartProducts();
  }
}
