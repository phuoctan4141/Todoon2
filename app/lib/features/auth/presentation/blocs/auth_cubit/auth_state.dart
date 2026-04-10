part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class Unknown extends AuthState {}

final class Unauthenticated extends AuthState {}

final class Authenticated extends AuthState {}
