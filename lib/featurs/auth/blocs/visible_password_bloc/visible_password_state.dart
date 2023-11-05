part of 'visible_password_bloc.dart';

@immutable
sealed class VisiblePasswordState {}

final class VisiblePasswordInitial extends VisiblePasswordState {}

final class VisiblePassword extends VisiblePasswordState {
  final bool isVisible;
  VisiblePassword({required this.isVisible});
}
