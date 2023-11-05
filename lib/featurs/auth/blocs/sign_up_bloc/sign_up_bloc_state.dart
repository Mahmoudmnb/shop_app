part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpBlocState {}

final class SignUpBlocInitial extends SignUpBlocState {}

final class IsSignUp extends SignUpBlocState {
  final bool isSignUp;
  IsSignUp({required this.isSignUp});
}
