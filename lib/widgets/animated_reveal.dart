import 'package:flutter/material.dart';

class AnimatedReveal extends StatefulWidget {
  const AnimatedReveal({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.06),
    this.duration = const Duration(milliseconds: 700),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;
  final Duration duration;

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (!mounted) {
        return;
      }
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : widget.offset,
        child: widget.child,
      ),
    );
  }
}
