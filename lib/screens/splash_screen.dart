import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/app_background.dart';
import '../widgets/app_logo.dart';
import '../widgets/glass_panel.dart';
import '../widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _openLogin(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
  }

  void _openSignup(BuildContext context) {
    Navigator.of(context).pushNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final heroWidth = width > 480 ? 420.0 : double.infinity;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SvgPicture.asset(
                'assets/images/warehouse_scene.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.76),
                    AppColors.background.withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AppBackground(child: const SizedBox.expand()),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedReveal(child: AppLogo()),
                        Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: heroWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AnimatedReveal(
                                  delay: Duration(milliseconds: 120),
                                  child: _HeroBadge(),
                                ),
                                const SizedBox(height: 18),
                                AnimatedReveal(
                                  delay: const Duration(milliseconds: 220),
                                  child: Text(
                                    'STAY SAFE\nON EVERY\nFACTORY SHIFT',
                                    style: textTheme.displayLarge?.copyWith(
                                      fontSize: width > 420 ? 56 : 48,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                AnimatedReveal(
                                  delay: const Duration(milliseconds: 320),
                                  child: Text(
                                    'Get quick access to PPE reminders, unsafe-zone alerts, and shift safety updates before you step onto the factory floor.',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                AnimatedReveal(
                                  delay: const Duration(milliseconds: 420),
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      AppActionButton(
                                        label: 'Login',
                                        icon: Icons.arrow_forward_rounded,
                                        onPressed: () => _openLogin(context),
                                      ),
                                      AppActionButton(
                                        label: 'Create Account',
                                        icon: Icons.person_add_alt_1_rounded,
                                        isPrimary: false,
                                        onPressed: () => _openSignup(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      radius: 999,
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
          ),
          Text(
            'FACTORY WORKER SAFETY APP',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
