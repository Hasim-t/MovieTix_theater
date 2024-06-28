part of 'authbloc_bloc.dart';

@immutable
sealed class AuthblocState {}

final class AuthblocInitial extends AuthblocState {}

class AuthLoading extends AuthblocState {}

class Authenticated extends AuthblocState {
  User? user;
  Authenticated(this.user);
}

class UnAutheticated extends AuthblocState {}

class AutheticatedError extends AuthblocState {
  final String msg;

  AutheticatedError({required this.msg});

}
