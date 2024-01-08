part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

class ChangKindOfOrderState extends OrdersState {}

class ChanegNumOfCharacterState extends OrdersState {}

class ChangeRating extends OrdersState {}

class IsLoading extends OrdersState {}
