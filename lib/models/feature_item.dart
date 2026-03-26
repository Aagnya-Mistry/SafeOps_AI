import 'package:flutter/material.dart';

class FeatureItem {
  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color tone;
}
