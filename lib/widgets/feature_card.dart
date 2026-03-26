import 'package:flutter/material.dart';

import '../models/feature_item.dart';
import '../theme/app_colors.dart';
import 'glass_panel.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({required this.item, super.key});

  final FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: item.tone.withValues(alpha: 0.14),
              border: Border.all(color: item.tone.withValues(alpha: 0.24)),
            ),
            child: Icon(item.icon, color: item.tone),
          ),
          const SizedBox(height: 18),
          Text(item.title, style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
