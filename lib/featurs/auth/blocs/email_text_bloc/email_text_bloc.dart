import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'email_text_event.dart';
part 'email_text_state.dart';

class EmailTextBloc extends Bloc<EmailTextEvent, EmailTextState> {
  EmailTextBloc() : super(EmailTextInitial()) {
    on<EmailTextEvent>((event, emit) {
      if (event is ChangeEmailText) {
        emit(EmailText(emailText: event.emailText));
      }
    });
  }
}
