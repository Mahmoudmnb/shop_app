part of 'wishlist_cubit.dart';

@immutable
sealed class WishlistState {}

final class WishlistInitial extends WishlistState {}

class ChangKindOfOrderState extends WishlistState {}

class ChanegNumOfCharacterState extends WishlistState {}

class ChangeRating extends WishlistState {}

class IsLoading extends WishlistState {}
