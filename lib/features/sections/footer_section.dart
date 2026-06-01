import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// Footer: brand mark + tagline, quick links, social icons, and a copyright row.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.onNavigate});

  /// Maps a quick-link label to a scroll target.
  final void Function(String label) onNavigate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final id = PortfolioData.identity;
    final isMobile = Responsive.isMobile(context);

    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: AppSpace.brSm,
                gradient: app.gradient(),
              ),
              child: const Icon(Icons.flutter_dash, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 11),
            Text(
              'Kshitij Passi',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            id.tagline,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.6,
              color: palette.textTertiary,
            ),
          ),
        ),
      ],
    );

    final links = Wrap(
      spacing: 28,
      runSpacing: 12,
      children: [
        for (final l in const ['About', 'Skills', 'Projects', 'Experience', 'Contact'])
          _FooterLink(label: l, onTap: () => onNavigate(l)),
      ],
    );

    return Column(
      children: [
        Container(
          height: 1,
          color: palette.border,
        ),
        SectionShell(
          topPad: 56,
          bottomPad: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brand,
                        const SizedBox(height: 28),
                        links,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        brand,
                        Flexible(child: Align(
                          alignment: Alignment.topRight,
                          child: links,
                        )),
                      ],
                    ),
              const SizedBox(height: 36),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 14,
                children: [
                  Text(
                    '© 2026 Kshitij Passi · Built with Flutter',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: palette.textTertiary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final s in id.socials) ...[
                        _FooterIcon(
                          icon: s.icon,
                          url: s.url,
                          tooltip: s.label,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _hover ? palette.textPrimary : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FooterIcon extends StatefulWidget {
  const _FooterIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });
  final IconData icon;
  final String url;
  final String tooltip;

  @override
  State<_FooterIcon> createState() => _FooterIconState();
}

class _FooterIconState extends State<_FooterIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: AnimatedContainer(
            duration: AppSpace.fast,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _hover ? palette.surface2 : palette.glass,
              border: Border.all(color: _hover ? app.accentA : palette.border),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: _hover ? palette.textPrimary : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
