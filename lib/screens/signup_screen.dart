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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter your email and password.');
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await SupabaseAuthService.signUpWithEmailPassword(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!result.isSuccess) {
      _showMessage(result.message ?? 'Signup failed.');
      return;
    }

    _redirectToHome();
  }

  Future<void> _signupWithGoogle() async {
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

  void _openLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
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
                          const Expanded(child: _SignupHero()),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _SignupCard(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isSubmitting: _isSubmitting,
                              onCreateAccount: _createAccount,
                              onGoogleSignup: _signupWithGoogle,
                              onBackToLogin: _openLogin,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SignupHero(compact: true),
                          const SizedBox(height: 24),
                          _SignupCard(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isSubmitting: _isSubmitting,
                            onCreateAccount: _createAccount,
                            onGoogleSignup: _signupWithGoogle,
                            onBackToLogin: _openLogin,
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

class _SignupHero extends StatelessWidget {
  const _SignupHero({this.compact = false});

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
              'Create your worker account and join your shift team.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Sign up to receive factory safety alerts, PPE reminders, and important notices for your assigned work areas.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            const _ChecklistItem(label: 'Shift-based safety alerts'),
            const SizedBox(height: 12),
            const _ChecklistItem(label: 'PPE reminder access'),
            const SizedBox(height: 12),
            const _ChecklistItem(label: 'Zone-specific notices'),
          ],
        ),
      ),
    );
  }
}

class _SignupCard extends StatelessWidget {
  const _SignupCard({
    required this.emailController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onCreateAccount,
    required this.onGoogleSignup,
    required this.onBackToLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleSignup;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      delay: const Duration(milliseconds: 120),
      child: GlassPanel(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign Up', style: Theme.of(context).textTheme.headlineLarge),
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
              hintText: 'Create a password',
              obscureText: true,
            ),
            const SizedBox(height: 22),
            AppActionButton(
              label: isSubmitting ? 'Creating...' : 'Create Account',
              icon: Icons.arrow_forward_rounded,
              expand: true,
              onPressed: isSubmitting ? () {} : onCreateAccount,
            ),
            const SizedBox(height: 12),
            AppActionButton(
              label: 'Sign Up with Google',
              icon: Icons.g_mobiledata_rounded,
              isPrimary: false,
              expand: true,
              onPressed: isSubmitting ? () {} : onGoogleSignup,
            ),
            const SizedBox(height: 12),
            AppActionButton(
              label: 'Back to Login',
              icon: Icons.login_rounded,
              isPrimary: false,
              expand: true,
              onPressed: isSubmitting ? () {} : onBackToLogin,
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                SupabaseAuthService.isConfigured
                    ? 'Use email/password or continue with Google.'
                    : 'Configure Supabase URL and anon key to enable signup.',
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

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
