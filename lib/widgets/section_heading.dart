import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    required this.description,
    super.key,
    this.eyebrow = 'COMMAND SURFACE',
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.accentBright,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(
          description,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
