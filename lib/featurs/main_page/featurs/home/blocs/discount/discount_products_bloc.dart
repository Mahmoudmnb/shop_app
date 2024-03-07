import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discount_products_event.dart';
part 'discount_products_state.dart';

class DiscountProductsBloc
    extends Bloc<DiscountProductsEvent, DiscountProductsState> {
  DiscountProductsBloc() : super(DiscountProductsInitial()) {
    on<DiscountProductsEvent>((event, emit) {
      if (event is GetDiscountProducts) {
        emit(DiscountProductsData(discountProducts: event.discountProducts));
      } else if (event is ChangeIsSearchEvent) {
        emit(IsSearchState(isSearch: event.isSearch));
      } else if (event is SearchInDiscount) {
        emit(SearchInDiscountResult(searchResult: event.searchResult));
      } else if (event is GetAllDiscountEvent) {
        emit(AllDiscountProductState(
            allDiscountProducts: event.allDiscountProducts));
      } else if (event is ChangeIsNewProductsFounded) {
        emit(IsNewProductsFounded(isFounded: event.isFounded));
      } else if (event is ChangeIsDisCountUpdated) {
        emit(
            IsDisCountUpdatedEvent(isDiscountUpdated: event.isDisCountUpdated));
      }
    });
  }
}
