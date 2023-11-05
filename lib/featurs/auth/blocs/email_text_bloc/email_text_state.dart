part of 'email_text_bloc.dart';

@immutable
sealed class EmailTextState {}

final class EmailTextInitial extends EmailTextState {}

final class EmailText extends EmailTextState {
  final String emailText;
  EmailText({required this.emailText});
}
