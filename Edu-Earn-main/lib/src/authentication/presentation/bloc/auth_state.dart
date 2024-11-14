part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class GoogleAuthSuccess extends AuthState {
  final UserCredential userCred;

  GoogleAuthSuccess({required this.userCred});
}

final class AuthSuccess extends AuthState {}

final class UserInfoLoaded extends AuthState {
  final UserEntity user;

  UserInfoLoaded({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
