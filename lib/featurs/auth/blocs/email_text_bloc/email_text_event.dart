part of 'email_text_bloc.dart';

@immutable
sealed class EmailTextEvent {}

final class ChangeEmailText extends EmailTextEvent {
  final String emailText;
  ChangeEmailText({required this.emailText});
}

final class ChangeToInit extends EmailTextEvent {
  ChangeToInit();
}
