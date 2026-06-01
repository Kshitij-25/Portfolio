import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_scope.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Monospace pill tag (matches `.chip`): hover brightens text + accent border
/// and lifts slightly.
class ChipTag extends StatefulWidget {
  const ChipTag(this.label, {super.key, this.interactive = true});

  final String label;
  final bool interactive;

  @override
  State<ChipTag> createState() => _ChipTagState();
}

class _ChipTagState extends State<ChipTag> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final active = widget.interactive && _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppSpace.fast,
        curve: AppSpace.ease,
        transform: Matrix4.translationValues(0, active ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: AppSpace.pill,
          color: palette.glass,
          border: Border.all(
            color: active ? app.accentA : palette.border,
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            letterSpacing: 0.2,
            color: active ? palette.textPrimary : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}
