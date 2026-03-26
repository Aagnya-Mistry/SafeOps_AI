import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  const SupabaseAuthService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static bool get isConfigured => SupabaseConfig.isConfigured;

  static Session? get currentSession =>
      isConfigured ? _client.auth.currentSession : null;

  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  static Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      return const AuthResult.failure(
        'Supabase is not configured. Set SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null && response.user == null) {
        return const AuthResult.failure('Login failed. Please try again.');
      }

      return const AuthResult.success();
    } on AuthException catch (error) {
      return AuthResult.failure(error.message);
    } catch (_) {
      return const AuthResult.failure(
        'Unable to connect to Supabase right now.',
      );
    }
  }

  static Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      return const AuthResult.failure(
        'Supabase is not configured. Set SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.session != null) {
        return const AuthResult.success();
      }

      return const AuthResult.failure(
        'Signup created the user, but no session was returned. If Confirm email is enabled in Supabase Auth, verify the email first or disable email confirmation for direct sign-in.',
      );
    } on AuthException catch (error) {
      return AuthResult.failure(error.message);
    } catch (_) {
      return const AuthResult.failure(
        'Unable to connect to Supabase right now.',
      );
    }
  }

  static Future<AuthResult> signInWithGoogle() async {
    if (!isConfigured) {
      return const AuthResult.failure(
        'Supabase is not configured. Set SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
      return const AuthResult.success();
    } on AuthException catch (error) {
      return AuthResult.failure(error.message);
    } catch (_) {
      return const AuthResult.failure(
        'Unable to start Google sign-in right now.',
      );
    }
  }

  static Future<void> signOut() async {
    if (!isConfigured) {
      return;
    }

    await _client.auth.signOut();
  }
}

class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}

class AuthResult {
  const AuthResult._({
    required this.isSuccess,
    this.message,
  });

  const AuthResult.success() : this._(isSuccess: true);

  const AuthResult.failure(String message)
    : this._(isSuccess: false, message: message);

  final bool isSuccess;
  final String? message;
}
