part of 'check_out_cubit.dart';

@immutable
sealed class CheckOutState {}

final class CheckOutInitial extends CheckOutState {}

class ChangeAddressState extends CheckOutState {}

class ChangeMethodState extends CheckOutState {}

class ChangePayState extends CheckOutState {}

class ChangeAgreeState extends CheckOutState {}
