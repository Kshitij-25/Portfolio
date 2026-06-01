import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';

class MobileMenuItem {
  const MobileMenuItem(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

/// Full-screen mobile navigation: slides in from the right with a staggered
/// list of section links and a theme toggle.
Future<void> showMobileMenu(
  BuildContext context, {
  required List<MobileMenuItem> sections,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Menu',
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _MobileMenu(sections: sections),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppSpace.easeOut);
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(curved),
        child: child,
      );
    },
  );
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.sections});
  final List<MobileMenuItem> sections;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);

    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.82,
          height: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border(left: BorderSide(color: palette.borderStrong)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.surface2,
                          border: Border.all(color: palette.border),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 19, color: palette.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                for (var i = 0; i < sections.length; i++)
                  _MenuRow(
                    item: sections[i],
                    onTap: () {
                      Navigator.of(context).pop();
                      sections[i].onTap();
                    },
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    app.toggleTheme();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: AppSpace.pill,
                      color: palette.surface2,
                      border: Border.all(color: palette.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          app.isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 18,
                          color: palette.textPrimary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          app.isDark ? 'Light mode' : 'Dark mode',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
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

class _MenuRow extends StatefulWidget {
  const _MenuRow({required this.item, required this.onTap});
  final MobileMenuItem item;
  final VoidCallback onTap;

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: AppSpace.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            borderRadius: AppSpace.br,
            color: _hover ? palette.surface2 : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(widget.item.icon, size: 20, color: app.accentA),
              const SizedBox(width: 16),
              Text(
                widget.item.label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
