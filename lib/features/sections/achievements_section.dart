import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animated_counter.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// Achievements: animated metric cards + a GitHub-style contribution heatmap
/// + a certifications strip.
class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Achievements',
            title: 'Numbers that ',
            titleAccent: 'tell the story.',
          ),
          SizedBox(height: 40),
          _MetricGrid(items: PortfolioData.achievements),
          SizedBox(height: 32),
          RevealOnScroll(child: _Heatmap()),
          SizedBox(height: 24),
          RevealOnScroll(child: _CertStrip()),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.items});
  final List<Achievement> items;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.value(context, mobile: 2, tablet: 3, desktop: 3);
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 18.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < items.length; i++)
              SizedBox(
                width: width,
                child: RevealOnScroll(
                  delay: Duration(milliseconds: (i % cols) * 80),
                  child: _MetricCard(item: items[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});
  final Achievement item;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: AppSpace.brSm,
              color: app.accentA.withValues(alpha: 0.14),
            ),
            child: Icon(item.icon, size: 21, color: app.accentA),
          ),
          const SizedBox(height: 18),
          AnimatedCounter(
            value: item.value,
            suffix: item.suffix,
            decimals: item.decimals,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A faux GitHub contribution graph: 52 weeks × 7 days of intensity cells that
/// fade in column-by-column the first time it appears.
class _Heatmap extends StatefulWidget {
  const _Heatmap();

  @override
  State<_Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<_Heatmap>
    with SingleTickerProviderStateMixin {
  static const weeks = 52;
  static const days = 7;
  late final List<List<int>> _grid;
  late final AnimationController _controller;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(7);
    _grid = List.generate(
      weeks,
      (w) => List.generate(days, (d) {
        // bias toward some activity, with denser recent weeks
        final base = rng.nextDouble();
        final recency = w / weeks;
        final v = base * 0.6 + recency * 0.5 + (rng.nextDouble() * 0.3);
        if (v < 0.45) return 0;
        if (v < 0.7) return 1;
        if (v < 0.9) return 2;
        if (v < 1.05) return 3;
        return 4;
      }),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    if (dy < MediaQuery.sizeOf(context).height - 40) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  Color _cellColor(int level, Color accent, Color empty) {
    if (level == 0) return empty;
    return accent.withValues(alpha: 0.25 + level * 0.18);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);

    return GlassCard(
      hoverLift: false,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 17, color: app.accentA),
              const SizedBox(width: 9),
              Text(
                '1,240 contributions in the last year',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 3.0;
              final cell = ((constraints.maxWidth - gap * (weeks - 1)) / weeks)
                  .clamp(5.0, 14.0);
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final progress = _controller.value * weeks;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var w = 0; w < weeks; w++)
                          Padding(
                            padding: const EdgeInsets.only(right: gap),
                            child: Column(
                              children: [
                                for (var d = 0; d < days; d++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: gap),
                                    child: Opacity(
                                      opacity: (progress - w).clamp(0.0, 1.0),
                                      child: Container(
                                        width: cell,
                                        height: cell,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.5),
                                          color: _cellColor(
                                            _grid[w][d],
                                            app.accentA,
                                            palette.surface2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 11, color: palette.textTertiary)),
              const SizedBox(width: 7),
              for (var l = 0; l < 5; l++)
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: _cellColor(l, app.accentA, palette.surface2),
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Text('More',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 11, color: palette.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertStrip extends StatelessWidget {
  const _CertStrip();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final c in PortfolioData.certifications)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: AppSpace.pill,
              color: palette.glass,
              border: Border.all(color: palette.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 16, color: app.accentA),
                const SizedBox(width: 9),
                Text(
                  c,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
