part of 'discount_products_bloc.dart';

@immutable
sealed class DiscountProductsEvent {}

class GetDiscountProducts extends DiscountProductsEvent {
  final List<Map<String, dynamic>> discountProducts;
  GetDiscountProducts({required this.discountProducts});
}

class ChangeIsSearchEvent extends DiscountProductsEvent {
  final bool isSearch;
  ChangeIsSearchEvent({required this.isSearch});
}

class SearchInDiscount extends DiscountProductsEvent {
  final List<Map<String, dynamic>> searchResult;
  SearchInDiscount({required this.searchResult});
}

class GetAllDiscountEvent extends DiscountProductsEvent {
  final List<Map<String, dynamic>> allDiscountProducts;
  GetAllDiscountEvent({required this.allDiscountProducts});
}

class ChangeIsNewProductsFounded extends DiscountProductsEvent {
  final bool isFounded;
  ChangeIsNewProductsFounded({required this.isFounded});
}

class ChangeIsDisCountUpdated extends DiscountProductsEvent {
  final bool isDisCountUpdated;
  ChangeIsDisCountUpdated({required this.isDisCountUpdated});
}
