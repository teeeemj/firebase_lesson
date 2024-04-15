part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthResetPassword extends AuthState {}

final class AuthLogout extends AuthState {}

final class AuthError extends AuthState {
  final String errorText;

  AuthError({required this.errorText});
}
