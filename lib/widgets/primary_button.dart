import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppActionButton extends StatefulWidget {
  const AppActionButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isPrimary = true,
    this.expand = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool expand;

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedScale(
      scale: _pressed ? 0.98 : (_hovered ? 1.01 : 1),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: widget.isPrimary
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accentBright, AppColors.accent],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    AppColors.surfaceElevated.withValues(alpha: 0.82),
                  ],
                ),
          border: Border.all(
            color: widget.isPrimary
                ? AppColors.accentBright.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            if (widget.isPrimary || _hovered)
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 12),
                color:
                    (widget.isPrimary
                            ? AppColors.accent
                            : AppColors.accentBright)
                        .withValues(alpha: _hovered ? 0.26 : 0.18),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: widget.expand
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (widget.icon != null) ...[
              const SizedBox(width: 10),
              Icon(widget.icon, size: 18, color: AppColors.textPrimary),
            ],
          ],
        ),
      ),
    );

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onPressed,
            child: child,
          ),
        ),
      ),
    );

    if (!widget.expand) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
