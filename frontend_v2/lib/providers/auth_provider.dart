import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  UserCredential? _userCredential;

  //?getters for components
  bool get isLoading => _isLoading;
  UserCredential? get userCredential => _userCredential;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _userCredential = await _authService.loginUser(email, password);

    _isLoading = false;
    notifyListeners();

    return _userCredential != null ? null : "Login failed. Check credentials.";
  }

  Future<void> logout() async {
    await _authService.logoutUser();
    _userCredential = null;
    notifyListeners();
  }
}
