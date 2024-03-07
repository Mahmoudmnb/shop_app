part of 'wishlist_cubit.dart';

@immutable
sealed class WishListState {}

final class WishlistInitial extends WishListState {}

class ChangKindOfOrderState extends WishListState {}

class ChanegNumOfCharacterState extends WishListState {}

class ChangeRating extends WishListState {}

class IsLoading extends WishListState {}

