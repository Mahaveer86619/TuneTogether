import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunetogether/common/app_constants/app_constants.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final Logger _logger;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AppUserCubit({
    required Logger logger,
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _logger = logger,
        _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        super(AppUserInitial());

  // authenticate user
  Future<void> authenticateUser(
    UserEntity user,
  ) async {
    final Map<String, dynamic> userMap = {
      'id': user.id,
      'email': user.email,
      'username': user.username,
    };
    await saveUser(userMap);

    emit(AppUserAuthenticated());
  }

  // load user
  Future<void> loadUser() async {
    final user = await getUser();
    if (user != null) {
      emit(AppUserAuthenticated());
    } else {
      emit(AppUserInitial());
    }
  }

  // save user
  Future<void> saveUser(Map<String, dynamic> userMap) async {
    try {
      await _sharedPreferences.setString(prefUserKey, jsonEncode(userMap));
      _logger.i('User saved successfully');
    } catch (e) {
      _logger.e('Error saving user: $e');
      rethrow;
    }
  }

  // get user
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final userString = _sharedPreferences.getString(prefUserKey);
      if (userString != null) {
        return jsonDecode(userString);
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting user: $e');
      return null;
    }
  }

  // remove user
  Future<void> signOut() async {
    await _sharedPreferences.remove(prefUserKey);
    removeToken();
    emit(AppUserInitial());
  }

  // save Token and Refresh Token
  Future<void> saveToken(String token, String refreshToken) async {
    await _sharedPreferences.setString(prefTokenKey, token);
    await _sharedPreferences.setString(prefRefreshTokenKey, refreshToken);
    emit(AppUserAuthenticated());
  }

  // get Token
  Future<String?> getToken() async {
    try {
      final tokenString = _sharedPreferences.getString(prefTokenKey);
      if (tokenString != null) {
        return tokenString;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting token: $e');
      return null;
    }
  }

  // get Refresh Token
  Future<String?> getRefreshToken() async {
    try {
      final refreshTokenString =
          _sharedPreferences.getString(prefRefreshTokenKey);
      if (refreshTokenString != null) {
        return refreshTokenString;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting refresh token: $e');
      return null;
    }
  }

  // refresh Token
  Future<void> refreshToken(String token, String refreshToken) async {
    await _sharedPreferences.remove(prefTokenKey);
    await _sharedPreferences.remove(prefRefreshTokenKey);

    saveToken(token, refreshToken);
  }

  // remove Token and Refresh Token
  Future<void> removeToken() async {
    await _sharedPreferences.remove(prefTokenKey);
    await _sharedPreferences.remove(prefRefreshTokenKey);
    emit(AppUserInitial());
  }
}
