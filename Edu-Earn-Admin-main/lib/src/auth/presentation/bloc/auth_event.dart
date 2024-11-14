part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final Company company;

  AuthSignUp({required this.company});
}

final class AuthLogin extends AuthEvent {
  final Company company;

  AuthLogin({required this.company});
}

final class ContinueWithGoogle extends AuthEvent {}

final class GetUserInfo extends AuthEvent {}