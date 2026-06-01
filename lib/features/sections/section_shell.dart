import 'package:flutter/material.dart';

import '../../core/responsive/responsive.dart';

/// Consistent vertical rhythm + max-width wrapper for every page section.
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.topPad,
    this.bottomPad,
  });

  final Widget child;
  final double maxWidth;
  final double? topPad;
  final double? bottomPad;

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.value(context, mobile: 76.0, tablet: 100.0, desktop: 120.0);
    final gutter = Responsive.gutter(context);
    return Padding(
      padding: EdgeInsets.only(top: topPad ?? pad, bottom: bottomPad ?? pad),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Glowing horizontal hairline used between major sections (matches `.hr-glow`).
class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).dividerColor.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          stops: const [0, 0.2, 0.5, 1],
        ),
      ),
    );
  }
}
