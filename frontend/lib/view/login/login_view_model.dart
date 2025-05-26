import 'package:flutter/material.dart';
import 'package:memodot/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  bool get isLoading => _authService.isLoading;
  String? get error => _authService.error;

  Future<bool> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<bool> register(String username, String email, String password) {
    return _authService.register(username, email, password);
  }
}
