part of 'check_out_cubit.dart';

@immutable
sealed class CheckOutState {}

class CheckOutInitial extends CheckOutState {}

class ChangeAddressState extends CheckOutState {}

class ChangeMethodState extends CheckOutState {}

class ChangePayState extends CheckOutState {}

class ChangeAgreeState extends CheckOutState {}

class IsDefaultLoacatoinState extends CheckOutState {}

class IsLoadingState extends CheckOutState {}

class ChangeSelectedCountryCode extends CheckOutState {}
