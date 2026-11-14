import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/profile_model.dart';

class AuthService {
  final _client = SupabaseService.client;

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current user profile from profiles table
  Future<ProfileModel?> getCurrentProfile() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  /// Check if current user is admin
  Future<bool> isAdmin() async {
    final profile = await getCurrentProfile();
    return profile?.isAdmin ?? false;
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
