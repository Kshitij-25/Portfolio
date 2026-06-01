import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Frosted glass surface (matches `.glass`): translucent fill, blur, hairline
/// border, large radius. Optionally lifts + brightens its border on hover.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius,
    this.hoverLift = true,
    this.blur = 18,
    this.onTap,
    this.hoverBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? radius;
  final bool hoverLift;
  final double blur;
  final VoidCallback? onTap;
  final Color? hoverBorder;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = widget.radius ?? AppSpace.brLg;
    final lifted = widget.hoverLift && _hover;

    return RepaintBoundary(
      child: MouseRegion(
        cursor:
            widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppSpace.base,
            curve: AppSpace.ease,
            transform: lifted
                ? Matrix4.translationValues(0, -6, 0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: lifted
                    ? (widget.hoverBorder ?? palette.borderStrong)
                    : palette.border,
              ),
              boxShadow: lifted
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 50,
                        offset: const Offset(0, 26),
                      ),
                    ]
                  : const [],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blur,
                  sigmaY: widget.blur,
                ),
                child: Container(
                  padding: widget.padding,
                  color: palette.glass,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
