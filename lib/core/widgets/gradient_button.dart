import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

enum BtnVariant { primary, ghost }

/// Pill button matching `.btn-primary` / `.btn-ghost`: gradient fill or glass,
/// hover lift, active press-scale, optional leading/trailing icon.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = BtnVariant.primary,
    this.leading,
    this.trailing,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final BtnVariant variant;
  final IconData? leading;
  final IconData? trailing;
  final bool expand;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final palette = context.palette;
    final isPrimary = widget.variant == BtnVariant.primary;

    final fg = isPrimary ? Colors.white : palette.textPrimary;
    final content = DefaultTextStyle.merge(
      style: TextStyle(
        color: fg,
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
      ),
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) ...[
            Icon(widget.leading, size: 17, color: fg),
            const SizedBox(width: 9),
          ],
          Text(widget.label),
          if (widget.trailing != null) ...[
            const SizedBox(width: 9),
            Icon(widget.trailing, size: 17, color: fg),
          ],
        ],
      ),
    );

    final scale = _down ? 0.97 : (_hover ? 1.0 : 1.0);
    final dy = _hover && !_down ? -2.0 : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: AppSpace.fast,
          curve: AppSpace.ease,
          transform: Matrix4.translationValues(0, dy, 0)
            ..scaleByDouble(scale, scale, scale, 1),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            gradient: isPrimary ? app.gradient() : null,
            color: isPrimary ? null : palette.glass,
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : (_hover ? app.accentA : palette.borderStrong),
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: app.accentA.withValues(alpha: _hover ? 0.5 : 0.35),
                      blurRadius: _hover ? 44 : 30,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : const [],
          ),
          child: content,
        ),
      ),
    );
  }
}
