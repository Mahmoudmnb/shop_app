part of 'products_cubit.dart';

@immutable
abstract class AddToCartState {}

class ProductsInitial extends AddToCartState {}

class ProductsRemoveElement extends AddToCartState {}

class ProductsAddElement extends AddToCartState {}

class ProductsFetchData extends AddToCartState {}
