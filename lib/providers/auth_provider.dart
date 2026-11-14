import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _profile != null;
  bool get isAdmin => _profile?.isAdmin ?? false;

  /// Sign in and fetch profile
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      _profile = await _authService.getCurrentProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Try to restore session on app start
  Future<void> tryRestoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _authService.getCurrentProfile();
    } catch (_) {
      _profile = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
