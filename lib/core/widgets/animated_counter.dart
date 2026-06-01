import 'package:flutter/material.dart';

import 'reveal_on_scroll.dart' show RevealOnScroll;

/// Counts up from 0 to [value] the first time it scrolls into view, then holds.
/// Uses the same scroll-position trigger as [RevealOnScroll] so numbers animate
/// exactly when the card appears.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.suffix = '',
    this.decimals = 0,
    this.style,
    this.duration = const Duration(milliseconds: 1600),
  });

  final double value;
  final String suffix;
  final int decimals;
  final TextStyle? style;
  final Duration duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (dy < screenH - 40) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        final current = widget.value * t;
        final text = widget.decimals > 0
            ? current.toStringAsFixed(widget.decimals)
            : current.round().toString();
        return Text(
          '$text${widget.suffix}',
          style: (widget.style ?? const TextStyle()).copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}
