/// Application configuration constants
class AppConfig {
  static const String appName = 'Gun Shop WMS';
  static const String appVersion = '1.0.0';

  // Supabase credentials - loaded from environment
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
