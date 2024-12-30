part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

//* Email Auth
class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });
}

//* Social Auths
class GoogleAuthEvent extends AuthEvent {
  const GoogleAuthEvent();
}

class GithubAuthEvent extends AuthEvent {
  const GithubAuthEvent();
}

//* Phone Auth
class PhoneVerifyEvent extends AuthEvent {
  final String phone;

  const PhoneVerifyEvent({
    required this.phone,
  });
}

class PhoneAuthEvent extends AuthEvent {
  final String phone;
  final String code;

  const PhoneAuthEvent({
    required this.phone,
    required this.code,
  });
}

//* Forgot Password
class SendPassResetOtpEvent extends AuthEvent {
  final String email;

  const SendPassResetOtpEvent({
    required this.email,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String code;
  final String email;

  const VerifyOtpEvent({
    required this.code,
    required this.email,
  });
}

class ResetPassEvent extends AuthEvent {
  final String email;
  final String password;

  const ResetPassEvent({
    required this.email,
    required this.password,
  });
}