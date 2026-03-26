import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/compliance_point.dart';
import '../theme/app_colors.dart';

class ComplianceChart extends StatelessWidget {
  const ComplianceChart({required this.points, super.key});

  final List<CompliancePoint> points;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: 100,
          alignment: BarChartAlignment.spaceBetween,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.outline.withValues(alpha: 0.45),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 14,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipColor: (_) => AppColors.surfaceElevated,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final point = points[group.x.toInt()];
                return BarTooltipItem(
                  '${point.label}\n',
                  textTheme.labelLarge!.copyWith(color: AppColors.textPrimary),
                  children: [
                    TextSpan(
                      text: '${point.value.toStringAsFixed(0)}%',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.accentBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                interval: 20,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[value.toInt()].label,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          barGroups: [
            for (int index = 0; index < points.length; index++)
              BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: points[index].value,
                    width: 15,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.accent, AppColors.accentBright],
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: AppColors.surfaceMuted.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
