import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';

class DockItem {
  const DockItem(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// macOS-style floating dock pinned to bottom-center. Icons scale up on hover
/// and the active section is filled with the accent gradient.
class FloatingDock extends StatelessWidget {
  const FloatingDock({
    super.key,
    required this.items,
    required this.activeIndex,
  });

  final List<DockItem> items;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: ClipRRect(
          borderRadius: AppSpace.pill,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: AppSpace.pill,
                color: palette.surface.withValues(alpha: 0.7),
                border: Border.all(color: palette.borderStrong),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < items.length; i++)
                    _DockButton(
                      item: items[i],
                      active: i == activeIndex,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockButton extends StatefulWidget {
  const _DockButton({required this.item, required this.active});
  final DockItem item;
  final bool active;

  @override
  State<_DockButton> createState() => _DockButtonState();
}

class _DockButtonState extends State<_DockButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final scale = _hover ? 1.18 : 1.0;

    return Tooltip(
      message: widget.item.label,
      verticalOffset: 34,
      preferBelow: false,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.item.onTap,
          child: AnimatedContainer(
            duration: AppSpace.fast,
            curve: AppSpace.ease,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0)
              ..scaleByDouble(scale, scale, scale, 1),
            transformAlignment: Alignment.center,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: widget.active ? app.gradient() : null,
              color: widget.active
                  ? null
                  : (_hover ? palette.surface2 : Colors.transparent),
            ),
            child: Icon(
              widget.item.icon,
              size: 19,
              color: widget.active
                  ? Colors.white
                  : (_hover ? palette.textPrimary : palette.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
