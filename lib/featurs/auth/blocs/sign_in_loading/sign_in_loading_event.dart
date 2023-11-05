part of 'sign_in_loading_bloc.dart';

@immutable
sealed class SignInLoadingEvent {}

final class ChangeLoadingState extends SignInLoadingEvent {
  final bool isLoading;
  ChangeLoadingState({required this.isLoading});
}
