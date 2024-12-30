part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, authenticated }

sealed class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState({required this.status});

  @override
  List<Object> get props => [status];
}

final class AuthInitial extends AuthState {
  const AuthInitial() : super(status: AuthStatus.unauthenticated);
}

final class AuthLoading extends AuthState {
  const AuthLoading() : super(status: AuthStatus.unauthenticated);
}

final class AuthError extends AuthState {
  final String error;

  const AuthError(
    this.error
  ) : super(status: AuthStatus.unauthenticated);
}

// Auth Success
final class Authenticated extends AuthState {
  const Authenticated() : super(status: AuthStatus.authenticated);
}

// Forgot pass
final class SentPassResetCode extends AuthState {
  final String email;

  const SentPassResetCode(this.email) : super(status: AuthStatus.unauthenticated);
}

final class VerifiedPassResetCode extends AuthState {
  const VerifiedPassResetCode() : super(status: AuthStatus.unauthenticated);
}

final class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess() : super(status: AuthStatus.unauthenticated);
}

final class PassResetCodeError extends AuthState {
  final String error;

  const PassResetCodeError(
    this.error
  ) : super(status: AuthStatus.unauthenticated);
}
