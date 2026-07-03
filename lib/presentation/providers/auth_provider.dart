import 'package:flutter/material.dart';
import 'package:smart_attendance/domain/entities/user.dart';
import 'package:smart_attendance/domain/repositories/auth_repository.dart';
import 'package:smart_attendance/domain/usecases/login_usecase.dart';
import 'package:smart_attendance/domain/usecases/register_usecase.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AppAuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  late LoginUseCase _loginUseCase;
  late RegisterUseCase _registerUseCase;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _error;

  AppAuthProvider(this.authRepository) {
    _loginUseCase = LoginUseCase(authRepository);
    _registerUseCase = RegisterUseCase(authRepository);
    _checkCurrentUser();
  }

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get error => _error;

  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  /// Check if user is already logged in
  Future<void> _checkCurrentUser() async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final isLoggedIn = await authRepository.isUserLoggedIn();
      if (isLoggedIn) {
        _user = await authRepository.getCurrentUser();
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
      _error = null;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      _state = AuthState.loading;
      _error = null;
      notifyListeners();

      _user = await _loginUseCase(email, password);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String studentId,
  }) async {
    try {
      _state = AuthState.loading;
      _error = null;
      notifyListeners();

      _user = await _registerUseCase(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        studentId: studentId,
      );
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      await authRepository.logout();
      _user = null;
      _state = AuthState.unauthenticated;
      _error = null;
    } catch (e) {
      _state = AuthState.error;
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
