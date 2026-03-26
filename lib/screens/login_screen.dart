import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/app_background.dart';
import '../widgets/app_logo.dart';
import '../widgets/glass_panel.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<AuthState>? _authSubscription;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = SupabaseAuthService.authStateChanges.listen((state) {
      if (state.session != null) {
        _redirectToHome();
      }
    });

    if (SupabaseAuthService.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _redirectToHome();
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter your email and password.');
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await SupabaseAuthService.signInWithEmailPassword(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!result.isSuccess) {
      _showMessage(result.message ?? 'Login failed.');
      return;
    }

    _redirectToHome();
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isSubmitting = true);

    final result = await SupabaseAuthService.signInWithGoogle();

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!result.isSuccess) {
      _showMessage(result.message ?? 'Google sign-in failed.');
    }
  }

  void _openSignup() {
    Navigator.of(context).pushNamed('/signup');
  }

  void _redirectToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: width > 860
                    ? Row(
                        children: [
                          const Expanded(child: _AuthHero()),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _LoginCard(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isSubmitting: _isSubmitting,
                              onLogin: _login,
                              onGoogleLogin: _loginWithGoogle,
                              onSignup: _openSignup,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _AuthHero(compact: true),
                          const SizedBox(height: 24),
                          _LoginCard(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isSubmitting: _isSubmitting,
                            onLogin: _login,
                            onGoogleLogin: _loginWithGoogle,
                            onSignup: _openSignup,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      child: Padding(
        padding: EdgeInsets.only(right: compact ? 0 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(),
            const SizedBox(height: 28),
            Text(
              'Start your shift with the latest safety updates.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Log in to check PPE reminders, restricted-area notices, and alerts that matter to you on the factory floor.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _InfoChip(label: 'Shift safety alerts'),
                _InfoChip(label: 'PPE check reminders'),
                _InfoChip(label: 'Restricted zone notices'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.onSignup,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      delay: const Duration(milliseconds: 120),
      child: GlassPanel(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            _AuthField(
              controller: emailController,
              label: 'Email',
              hintText: 'worker@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _AuthField(
              controller: passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            const SizedBox(height: 22),
            AppActionButton(
              label: isSubmitting ? 'Signing In...' : 'Enter Home',
              icon: Icons.arrow_forward_rounded,
              expand: true,
              onPressed: isSubmitting ? () {} : onLogin,
            ),
            const SizedBox(height: 12),
            AppActionButton(
              label: 'Sign In with Google',
              icon: Icons.g_mobiledata_rounded,
              isPrimary: false,
              expand: true,
              onPressed: isSubmitting ? () {} : onGoogleLogin,
            ),
            const SizedBox(height: 12),
            AppActionButton(
              label: 'Create Account',
              icon: Icons.person_add_alt_1_rounded,
              isPrimary: false,
              expand: true,
              onPressed: isSubmitting ? () {} : onSignup,
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                SupabaseAuthService.isConfigured
                    ? 'Use your Supabase email/password or Google account.'
                    : 'Configure Supabase URL and anon key to enable login.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.accentBright),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
