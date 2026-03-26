import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_panel.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const _items = <_NavItem>[
    _NavItem(label: 'Detect', icon: Icons.visibility_rounded),
    _NavItem(label: 'Features', icon: Icons.widgets_rounded),
    _NavItem(label: 'Dashboard', icon: Icons.space_dashboard_rounded),
    _NavItem(label: 'CTA', icon: Icons.campaign_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(8),
      radius: 24,
      child: Row(
        children: [
          for (int index = 0; index < _items.length; index++) ...[
            Expanded(
              child: _NavButton(
                item: _items[index],
                selected: index == currentIndex,
                onTap: () => onSelected(index),
              ),
            ),
            if (index != _items.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: selected
            ? const LinearGradient(
                colors: [AppColors.accentBright, AppColors.accent],
              )
            : null,
        color: selected ? null : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
