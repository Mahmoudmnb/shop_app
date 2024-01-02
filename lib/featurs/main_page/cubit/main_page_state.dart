part of 'main_page_cubit.dart';

@immutable
sealed class MainPageState {}

final class MainPageInitial extends MainPageState {}

final class PageIndex extends MainPageState {}

final class AddLocationLoading extends MainPageState {}
final class UpdateProfilePage extends MainPageState {}

