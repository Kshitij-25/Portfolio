import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/widgets/animated_counter.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// About: bio + passion statement + a vertical journey timeline, plus a row of
/// animated stat cards.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final about = PortfolioData.about;
    final palette = context.palette;
    final isDesktop = Responsive.isDesktop(context);

    final bioBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in about.bio) ...[
          RevealOnScroll(
            child: Text(
              p,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                height: 1.7,
                color: palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
        const SizedBox(height: 6),
        RevealOnScroll(
          child: GlassCard(
            hoverLift: false,
            padding: const EdgeInsets.all(22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: AppScope.of(context).gradient(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    about.passion,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'About',
            title: 'Engineer first, ',
            titleAccent: 'pixel-perfectionist always.',
            subtitle: 'Four years turning ambitious ideas into shippable, '
                'delightful Flutter products.',
          ),
          const SizedBox(height: 56),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: bioBlock),
                    const SizedBox(width: 56),
                    Expanded(flex: 4, child: _Timeline(items: about.journey)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bioBlock,
                    const SizedBox(height: 40),
                    _Timeline(items: about.journey),
                  ],
                ),
          const SizedBox(height: 56),
          _StatRow(stats: PortfolioData.stats),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.items});
  final List<JourneyItem> items;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          RevealOnScroll(
            delay: Duration(milliseconds: i * 90),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: app.gradient(),
                        ),
                      ),
                      if (i != items.length - 1)
                        Expanded(
                          child: Container(
                            width: 1.5,
                            color: palette.border,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: i == items.length - 1 ? 0 : 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].year,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12.5,
                              color: app.accentA,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            items[i].title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].org,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            items[i].note,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              height: 1.5,
                              color: palette.textTertiary,
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
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stats});
  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.value(context, mobile: 2, desktop: 4);
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 18.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final s in stats)
              SizedBox(width: width, child: _StatCard(stat: s)),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});
  final StatItem stat;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return RevealOnScroll(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCounter(
              value: stat.value,
              suffix: stat.suffix,
              decimals: stat.decimals,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              stat.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: palette.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
