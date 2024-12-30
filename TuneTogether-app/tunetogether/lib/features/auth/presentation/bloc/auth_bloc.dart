import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_user_cubit/app_user_cubit.dart';
import 'package:tunetogether/common/helpers/data_state.dart';

import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
    required SignUpUsecase signUpUsecase,
    required SignInUsecase signInUsecase,
  })  : _appUserCubit = appUserCubit,
        _logger = logger,
        _signUpUsecase = signUpUsecase,
        _signInUsecase = signInUsecase,
        super(const AuthInitial()) {
    on<SignUpEvent>(_onSignUpEvent);
    on<SignInEvent>(_onSignInEvent);
    on<GoogleAuthEvent>(_onGoogleAuthEvent);
    on<GithubAuthEvent>(_onGithubAuthEvent);
    on<PhoneVerifyEvent>(_onPhoneVerifyEvent);
    on<PhoneAuthEvent>(_onPhoneAuthEvent);
    on<SendPassResetOtpEvent>(_onSendPassResetOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResetPassEvent>(_onResetPassEvent);
  }

  Future<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final resp = await _signUpUsecase.execute(
        params: SignUpUsecaseParams(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );

      if (resp is DataFailure) {
        _logger.e(resp.message!);
        emit(AuthError(resp.message!));
        return;
      }

      if (resp.data == null) {
        _logger.e('Something went wrong');
        emit(const AuthError('Something went wrong'));
        return;
      }

      // save tokens
      final token = resp.data!.token;
      final refreshToken = resp.data!.refreshToken;
      await _appUserCubit.saveToken(token, refreshToken);

      // extract other user info and save
      final userToSave = resp.data!.toEntity();
      await _appUserCubit.authenticateUser(userToSave);

      // emit success
      emit(const Authenticated());
    } catch (e) {
      _logger.e(e);
      emit(const AuthError('Something went wrong'));
    }
  }

  Future<void> _onSignInEvent(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final resp = await _signInUsecase.execute(
        params: SignInUsecaseParams(
          email: event.email,
          password: event.password,
        ),
      );

      if (resp is DataFailure) {
        _logger.e(resp.message!);
        emit(AuthError(resp.message!));
        return;
      }

      if (resp.data == null) {
        _logger.e('Something went wrong');
        emit(const AuthError('Something went wrong'));
        return;
      }

      // save tokens
      final token = resp.data!.token;
      final refreshToken = resp.data!.refreshToken;
      await _appUserCubit.saveToken(token, refreshToken);

      // extract other user info and save
      final userToSave = resp.data!.toEntity();
      await _appUserCubit.authenticateUser(userToSave);

      // emit success
      emit(const Authenticated());
    } catch (e) {
      _logger.e(e);
      emit(const AuthError('Something went wrong'));
    }
  }

  Future<void> _onGoogleAuthEvent(
    GoogleAuthEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onGithubAuthEvent(
    GithubAuthEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onPhoneVerifyEvent(
    PhoneVerifyEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onPhoneAuthEvent(
    PhoneAuthEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onSendPassResetOtpEvent(
    SendPassResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onResetPassEvent(
    ResetPassEvent event,
    Emitter<AuthState> emit,
  ) async {}
}
