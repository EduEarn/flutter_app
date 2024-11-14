part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final UserEntity user;

  AuthSignUp({required this.user});
}

final class AuthLogin extends AuthEvent {
  final UserEntity user;

  AuthLogin({required this.user});
}

final class ContinueWithGoogle extends AuthEvent {}

final class GetUserInfo extends AuthEvent {}
