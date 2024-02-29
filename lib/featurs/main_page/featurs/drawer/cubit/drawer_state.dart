part of 'drawer_cubit.dart';

sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

final class RefreshDrawer extends DrawerState {}

final class SelectedItem extends DrawerState {
  final int selectedItem;
  SelectedItem({required this.selectedItem});
}
