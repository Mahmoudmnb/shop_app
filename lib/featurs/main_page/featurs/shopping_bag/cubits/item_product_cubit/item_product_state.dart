part of 'item_product_cubit.dart';

@immutable
sealed class ItemProductState {}

final class ItemProductInitial extends ItemProductState {}

class ItemProductChanged extends ItemProductState {
  final Map<String, int> product;
  ItemProductChanged({required this.product});
}
