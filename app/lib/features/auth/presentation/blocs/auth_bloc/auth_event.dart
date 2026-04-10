part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckStatus extends AuthEvent {}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final class AuthSignOutEvent extends AuthEvent {}

final class AuthResetPassEvent extends AuthEvent {
  final String email;

  const AuthResetPassEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

// final class AuthChangePassEvent extends AuthEvent {
//   final String oldPassword;
//   final String newPassword;

//   const AuthChangePassEvent({
//     required this.oldPassword,
//     required this.newPassword,
//   });

//   @override
//   List<Object?> get props => [oldPassword, newPassword];
// }

// final class AuthUpdateProfileEvent extends AuthEvent {
//   final String displayName;

//   const AuthUpdateProfileEvent({required this.displayName});

//   @override
//   List<Object?> get props => [displayName];
// }

final class AuthRefreshEvent extends AuthEvent {}

final class AuthNavigateToSignUpEvent extends AuthEvent {}

final class AuthNavigateToForgotEvent extends AuthEvent {}

final class AuthNavigateToLoginEvent extends AuthEvent {}
