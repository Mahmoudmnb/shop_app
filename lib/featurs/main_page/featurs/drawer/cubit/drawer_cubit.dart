import 'package:flutter_bloc/flutter_bloc.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());
  changeSelectedItem(int item) {
    emit(SelectedItem(selectedItem: item));
  }

  void refreshDrawer() {
    emit(RefreshDrawer());
  }
}
