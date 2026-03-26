import 'package:flutter/material.dart';

import '../models/violation_event.dart';
import '../theme/app_colors.dart';

class ViolationChip extends StatelessWidget {
  const ViolationChip({required this.severity, super.key});

  final ViolationSeverity severity;

  Color get _color {
    switch (severity) {
      case ViolationSeverity.high:
        return AppColors.danger;
      case ViolationSeverity.medium:
        return AppColors.warning;
      case ViolationSeverity.critical:
        return AppColors.dangerDark;
    }
  }

  String get _label {
    switch (severity) {
      case ViolationSeverity.high:
        return 'HIGH';
      case ViolationSeverity.medium:
        return 'MED';
      case ViolationSeverity.critical:
        return 'CRITICAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = severity == ViolationSeverity.critical;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: isCritical ? 0.95 : 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _color.withValues(alpha: 0.28)),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isCritical ? AppColors.textPrimary : _color,
        ),
      ),
    );
  }
}
