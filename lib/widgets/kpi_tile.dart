import 'package:flutter/material.dart';

import '../models/kpi_metric.dart';
import '../theme/app_colors.dart';
import 'glass_panel.dart';

class KpiTile extends StatelessWidget {
  const KpiTile({required this.metric, super.key});

  final KpiMetric metric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: metric.tone.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              metric.label.toUpperCase(),
              style: textTheme.labelMedium?.copyWith(
                color: metric.tone,
                letterSpacing: 1.3,
              ),
            ),
          ),
          const Spacer(),
          Text(
            metric.value,
            style: textTheme.displayMedium?.copyWith(fontSize: 34),
          ),
          const SizedBox(height: 10),
          Text(
            metric.supportingText,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
