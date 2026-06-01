import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/gradient_button.dart';

class NavTarget {
  const NavTarget(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
}

/// Sticky top navigation: brand, section links, ⌘K trigger, theme toggle and a
/// primary CTA. Collapses to a menu button on mobile. Gains a stronger glass
/// background once the page is scrolled.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.targets,
    required this.activeIndex,
    required this.scrolled,
    required this.onOpenPalette,
    required this.onOpenMenu,
    required this.onContact,
  });

  final List<NavTarget> targets;
  final int activeIndex;
  final bool scrolled;
  final VoidCallback onOpenPalette;
  final VoidCallback onOpenMenu;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 900;
    final isMobile = compact;
    final gutter = Responsive.gutter(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: ClipRRect(
            borderRadius: AppSpace.pill,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AnimatedContainer(
                duration: AppSpace.base,
                curve: AppSpace.ease,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppSpace.pill,
                  color: scrolled
                      ? palette.surface.withValues(alpha: 0.72)
                      : palette.glass,
                  border: Border.all(
                    color: scrolled ? palette.borderStrong : palette.border,
                  ),
                ),
                child: Row(
                  children: [
                    _brand(context),
                    const Spacer(),
                    if (!isMobile) ...[
                      _links(context),
                      const SizedBox(width: 16),
                    ],
                    _iconPill(
                      context,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_rounded,
                              size: 15, color: palette.textSecondary),
                          if (!isMobile) ...[
                            const SizedBox(width: 6),
                            Text(
                              '⌘K',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: onOpenPalette,
                    ),
                    const SizedBox(width: 8),
                    _iconPill(
                      context,
                      child: Icon(
                        app.isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 16,
                        color: palette.textSecondary,
                      ),
                      onTap: app.toggleTheme,
                    ),
                    const SizedBox(width: 8),
                    if (isMobile)
                      _iconPill(
                        context,
                        child: Icon(Icons.menu_rounded,
                            size: 18, color: palette.textPrimary),
                        onTap: onOpenMenu,
                      )
                    else
                      GradientButton(label: "Let's talk", onPressed: onContact),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brand(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: AppSpace.brSm,
            gradient: app.gradient(),
            boxShadow: [
              BoxShadow(
                color: app.accentA.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.flutter_dash, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          'Kshitij.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _links(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < targets.length; i++)
          _NavLink(
            label: targets[i].label,
            active: i == activeIndex,
            onTap: targets[i].onTap,
          ),
      ],
    );
  }

  Widget _iconPill(BuildContext context,
      {required Widget child, required VoidCallback onTap}) {
    final palette = context.palette;
    return _Hoverable(
      builder: (hover) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppSpace.fast,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            color: hover ? palette.surface2 : palette.glass,
            border: Border.all(
              color: hover ? palette.borderStrong : palette.border,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final highlight = widget.active || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppSpace.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            color: widget.active ? palette.surface2 : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: highlight ? palette.textPrimary : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiny helper that rebuilds with the current hover state.
class _Hoverable extends StatefulWidget {
  const _Hoverable({required this.builder});
  final Widget Function(bool hover) builder;

  @override
  State<_Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<_Hoverable> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: widget.builder(_hover),
    );
  }
}
