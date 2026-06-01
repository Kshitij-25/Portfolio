import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// Experience: a left-rail vertical timeline of roles with bulleted highlights.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = PortfolioData.experience;
    final palette = context.palette;
    final app = AppScope.of(context);

    return SectionShell(
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Experience',
            title: 'Where I\'ve ',
            titleAccent: 'made an impact.',
          ),
          const SizedBox(height: 48),
          for (var i = 0; i < items.length; i++)
            RevealOnScroll(
              delay: Duration(milliseconds: i * 80),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // rail
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: app.gradient(),
                            boxShadow: [
                              BoxShadow(
                                color: app.accentA.withValues(alpha: 0.5),
                                blurRadius: 12,
                              ),
                            ],
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
                    const SizedBox(width: 22),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: i == items.length - 1 ? 0 : 22),
                        child: GlassCard(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    items[i].role,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: palette.textPrimary,
                                    ),
                                  ),
                                  _TypeBadge(label: items[i].type),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Text(
                                    items[i].company,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      color: app.accentA,
                                    ),
                                  ),
                                  Text(
                                    items[i].period,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12.5,
                                      color: palette.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              for (final p in items[i].points)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: app.accentA,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 11),
                                      Expanded(
                                        child: Text(
                                          p,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14.5,
                                            height: 1.55,
                                            color: palette.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: AppSpace.pill,
        color: palette.surface2,
        border: Border.all(color: palette.border),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          color: palette.textTertiary,
        ),
      ),
    );
  }
}
