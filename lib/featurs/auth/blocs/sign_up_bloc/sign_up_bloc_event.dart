part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpBlocEvent {}

final class ChangeBetweenSignUpOrSignIn extends SignUpBlocEvent {
  final bool isSignUp;
  ChangeBetweenSignUpOrSignIn({required this.isSignUp});
}
