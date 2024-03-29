import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_loading_event.dart';
part 'sign_in_loading_state.dart';

class SignInLoadingBloc extends Bloc<SignInLoadingEvent, SignInLoadingState> {
  SignInLoadingBloc() : super(SignInLoadingInitial()) {
    on<SignInLoadingEvent>((event, emit) {
      if (event is ChangeLoadingState) {
        emit(IsLoading(isLoading: event.isLoading));
      } else if (event is ChangeSkipButtonLoading) {
        emit(IsSkipButtonLoading(isLoading: event.isLoading));
      }
    });
  }
}
