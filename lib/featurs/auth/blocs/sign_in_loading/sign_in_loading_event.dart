part of 'sign_in_loading_bloc.dart';

@immutable
sealed class SignInLoadingEvent {}

final class ChangeLoadingState extends SignInLoadingEvent {
  final bool isLoading;
  ChangeLoadingState({required this.isLoading});
}

final class ChangeSkipButtonLoading extends SignInLoadingEvent {
  final bool isLoading;
  ChangeSkipButtonLoading({required this.isLoading});
}
