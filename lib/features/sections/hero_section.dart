import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'hero_mockup.dart';
import 'section_shell.dart';

/// Full-height landing hero: availability pill, large display headline with a
/// gradient accent line, intro, CTAs, and the floating phone mockup. Copy and
/// mockup stagger in on first paint.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onContact,
    required this.onResume,
  });

  final VoidCallback onViewProjects;
  final VoidCallback onContact;
  final VoidCallback onResume;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    // Wait for the boot splash to fade, then play the entrance.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _step(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: AppSpace.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = PortfolioData.identity;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final copy = _buildCopy(context, id, isMobile);
    final mockup = _Reveal(
      animation: _step(0.35, 1.0),
      offset: const Offset(0, 40),
      child: const HeroMockup(),
    );

    return SectionShell(
      topPad: isMobile ? 130 : 150,
      bottomPad: isMobile ? 40 : 60,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: Center(child: mockup)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 56),
                Center(child: mockup),
              ],
            ),
    );
  }

  Widget _buildCopy(BuildContext context, Identity id, bool isMobile) {
    final palette = context.palette;
    final headlineSize =
        Responsive.value(context, mobile: 44.0, tablet: 60.0, desktop: 70.0);

    final headlineStyle = GoogleFonts.spaceGrotesk(
      fontSize: headlineSize,
      height: 1.02,
      letterSpacing: -headlineSize * 0.035,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Reveal(
          animation: _step(0.0, 0.5),
          child: _availabilityPill(context, id),
        ),
        const SizedBox(height: 26),
        _Reveal(
          animation: _step(0.1, 0.65),
          child: DefaultTextStyle.merge(
            style: headlineStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Building beautiful'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientText('cross-platform', style: headlineStyle),
                  ],
                ),
                const Text('experiences with Flutter.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        _Reveal(
          animation: _step(0.2, 0.75),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              id.intro,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 16 : 18,
                height: 1.6,
                color: palette.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 34),
        _Reveal(
          animation: _step(0.3, 0.85),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              GradientButton(
                label: 'View Projects',
                trailing: Icons.arrow_forward_rounded,
                onPressed: widget.onViewProjects,
              ),
              GradientButton(
                label: 'Download Resume',
                variant: BtnVariant.ghost,
                leading: Icons.file_download_outlined,
                onPressed: widget.onResume,
              ),
              GradientButton(
                label: 'Contact Me',
                variant: BtnVariant.ghost,
                leading: Icons.mail_outline_rounded,
                onPressed: widget.onContact,
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        _Reveal(
          animation: _step(0.4, 0.95),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  'Find me',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    color: palette.textTertiary,
                  ),
                ),
              ),
              for (final s in id.socials) _SocialIcon(link: s),
            ],
          ),
        ),
      ],
    );
  }

  Widget _availabilityPill(BuildContext context, Identity id) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: AppSpace.pill,
        color: palette.glass,
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Pulse(),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              'Available for new projects · ${id.location}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  const _SocialIcon({required this.link});
  final SocialLink link;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Tooltip(
      message: widget.link.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.link.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: AnimatedContainer(
            duration: AppSpace.fast,
            width: 38,
            height: 38,
            transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: _hover ? palette.surface2 : palette.glass,
              border: Border.all(
                color: _hover ? app.accentA : palette.border,
              ),
            ),
            child: Icon(
              widget.link.icon,
              size: 17,
              color: _hover ? palette.textPrimary : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse();
  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF3DDBB8);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          return SizedBox(
            width: 10,
            height: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 10 + t * 10,
                  height: 10 + t * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: green.withValues(alpha: (1 - t) * 0.5),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Fade + slide reveal driven by an external [Animation].
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.child,
    this.offset = const Offset(0, 22),
  });
  final Animation<double> animation;
  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - t), offset.dy * (1 - t)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
