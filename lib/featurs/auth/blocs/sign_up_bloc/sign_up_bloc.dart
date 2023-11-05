import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'sign_up_bloc_event.dart';
part 'sign_up_bloc_state.dart';

class SignUpBloc extends Bloc<SignUpBlocEvent, SignUpBlocState> {
  SignUpBloc() : super(SignUpBlocInitial()) {
    on<SignUpBlocEvent>((event, emit) {
      if (event is ChangeBetweenSignUpOrSignIn) {
        emit(IsSignUp(isSignUp: event.isSignUp));
      }
    });
  }
}
