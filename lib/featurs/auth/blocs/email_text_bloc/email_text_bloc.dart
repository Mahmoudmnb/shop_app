import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'email_text_event.dart';
part 'email_text_state.dart';

class EmailTextBloc extends Bloc<EmailTextEvent, EmailTextState> {
  EmailTextBloc() : super(EmailTextInitial()) {
    on<EmailTextEvent>((event, emit) {
      if (event is ChangeEmailText) {
        emit(EmailText(emailText: event.emailText));
      } else if (event is ChangeToInit) {
        emit(EmailTextInitial());
      }
    });
  }
}
