import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'services/supabase_auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  runApp(const SafeguardApp());
}

class SafeguardApp extends StatelessWidget {
  const SafeguardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safeguard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
      },
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return const SplashScreen();
    }

    return StreamBuilder<AuthState>(
      stream: SupabaseAuthService.authStateChanges,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        SupabaseAuthService.currentSession,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? SupabaseAuthService.currentSession;
        if (session != null) {
          return const HomeScreen();
        }
        return const SplashScreen();
      },
    );
  }
}
