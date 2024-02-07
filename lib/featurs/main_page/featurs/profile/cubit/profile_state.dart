part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ChangeAddressState extends ProfileState {}

class ChangeProfileImagePath extends ProfileState {}

class ChangeIsLogOutLoading extends ProfileState {}
