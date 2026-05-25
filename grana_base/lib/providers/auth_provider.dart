import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _emailKey = 'user_email';

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  String? _userId;
  String? _email;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  String? get userId => _userId;
  String? get email => _email;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null && !_isExpired(token)) {
      _userId = prefs.getString(_userIdKey);
      _email = prefs.getString(_emailKey);
      _isAuthenticated = true;
    } else {
      await _clearAuth();
    }

    notifyListeners();
  }

  bool _isExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = parts[1];
      final padded = payload.padRight((payload.length + 3) & ~3, '=');
      final decoded = jsonDecode(utf8.decode(base64Url.decode(padded)));
      final exp = decoded['exp'] as int?;
      if (exp == null) return false;
      return DateTime.now().millisecondsSinceEpoch ~/ 1000 > exp;
    } catch (_) {
      return true;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        _errorMessage = data['error'] ?? 'Erro ao entrar.';
        notifyListeners();
        return false;
      }

      await _saveAuth(
        token: data['token'] as String,
        userId: data['userId'] as String,
        email: data['email'] as String,
      );

      return true;
    } catch (_) {
      _errorMessage = 'Erro de conexão. Verifique se o servidor está rodando.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await ApiClient.post('/auth/register', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        _errorMessage = data['error'] ?? 'Erro ao cadastrar.';
        notifyListeners();
        return false;
      }

      await _saveAuth(
        token: data['token'] as String,
        userId: data['userId'] as String,
        email: data['email'] as String,
      );

      return true;
    } catch (_) {
      _errorMessage = 'Erro de conexão. Verifique se o servidor está rodando.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _clearAuth();
    _setLoading(false);
  }

  Future<void> _saveAuth({
    required String token,
    required String userId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);
    await ApiClient.saveToken(token);

    _isAuthenticated = true;
    _userId = userId;
    _email = email;
    notifyListeners();
  }

  Future<void> _clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await ApiClient.clearToken();

    _isAuthenticated = false;
    _userId = null;
    _email = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _clearError() => _errorMessage = null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
