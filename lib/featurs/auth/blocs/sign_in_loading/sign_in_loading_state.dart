part of 'sign_in_loading_bloc.dart';

@immutable
sealed class SignInLoadingState {}

final class SignInLoadingInitial extends SignInLoadingState {}

final class IsLoading extends SignInLoadingState {
  final bool isLoading;
  IsLoading({required this.isLoading});
}
