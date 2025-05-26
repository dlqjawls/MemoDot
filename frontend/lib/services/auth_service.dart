import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:memodot/core/constants.dart';
import 'package:memodot/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // 로그인 메서드
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];

        // 토큰 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);

        // 사용자 정보 설정
        _currentUser = UserModel.fromJson(userData);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = '로그인에 실패했습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 회원가입 메서드
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = '회원가입에 실패했습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    _currentUser = null;
    notifyListeners();
  }

  // 현재 사용자 정보 로드
  Future<bool> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

    if (token == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        await logout();
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      await logout();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
