import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/skill_bar.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'section_shell.dart';

/// Skills: animated proficiency bars on the left, grouped tech-stack cards on
/// the right.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final skills = PortfolioData.skills;

    // Top 6 skills get bars; everything is grouped into stack cards.
    final barSkills = skills.take(6).toList();
    final groups = <String, List<Skill>>{};
    for (final s in skills) {
      groups.putIfAbsent(s.group, () => []).add(s);
    }

    final bars = Column(
      children: [
        for (var i = 0; i < barSkills.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == barSkills.length - 1 ? 0 : 22),
            child: RevealOnScroll(
              delay: Duration(milliseconds: i * 70),
              child: SkillBar(name: barSkills[i].name, level: barSkills[i].level),
            ),
          ),
      ],
    );

    final stackCards = _StackGrid(groups: groups);

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Skills',
            title: 'A toolkit tuned for ',
            titleAccent: 'shipping.',
            subtitle:
                'Deep in the Flutter ecosystem, comfortable across the stack, '
                'and fluent in design tools.',
          ),
          const SizedBox(height: 56),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: bars),
                    const SizedBox(width: 56),
                    Expanded(flex: 5, child: stackCards),
                  ],
                )
              : Column(
                  children: [
                    bars,
                    const SizedBox(height: 40),
                    stackCards,
                  ],
                ),
        ],
      ),
    );
  }
}

class _StackGrid extends StatelessWidget {
  const _StackGrid({required this.groups});
  final Map<String, List<Skill>> groups;

  @override
  Widget build(BuildContext context) {
    final entries = groups.entries.toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 18.0;
        final twoCol = constraints.maxWidth > 360;
        final width = twoCol
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < entries.length; i++)
              SizedBox(
                width: width,
                child: RevealOnScroll(
                  delay: Duration(milliseconds: i * 80),
                  child: _GroupCard(title: entries[i].key, skills: entries[i].value),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.title, required this.skills});
  final String title;
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: app.gradient(),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in skills) _MiniChip(label: s.name),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatefulWidget {
  const _MiniChip({required this.label});
  final String label;

  @override
  State<_MiniChip> createState() => _MiniChipState();
}

class _MiniChipState extends State<_MiniChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppSpace.fast,
        transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: AppSpace.pill,
          color: _hover ? app.accentA.withValues(alpha: 0.14) : palette.surface2,
          border: Border.all(color: _hover ? app.accentA : palette.border),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _hover ? palette.textPrimary : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}
