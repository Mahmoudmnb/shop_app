part of 'visible_password_bloc.dart';

@immutable
sealed class VisiblePasswordEvent {}

final class ShowPassword extends VisiblePasswordEvent {}

final class HidePassword extends VisiblePasswordEvent {}
