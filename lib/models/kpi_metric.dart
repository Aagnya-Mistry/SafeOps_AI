import 'package:flutter/material.dart';

class KpiMetric {
  const KpiMetric({
    required this.label,
    required this.value,
    required this.supportingText,
    required this.tone,
  });

  final String label;
  final String value;
  final String supportingText;
  final Color tone;
}
