import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'visible_password_event.dart';
part 'visible_password_state.dart';

class VisiblePsswordBloc
    extends Bloc<VisiblePasswordEvent, VisiblePasswordState> {
  VisiblePsswordBloc() : super(VisiblePasswordInitial()) {
    on<VisiblePasswordEvent>((event, emit) {
      if (event is ShowPassword) {
        emit(VisiblePassword(isVisible: true));
      } else if (event is HidePassword) {
        emit(VisiblePassword(isVisible: false));
      }
    });
  }
}
