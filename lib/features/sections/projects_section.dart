import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive.dart';
import '../../core/state/app_scope.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models.dart';
import '../../data/portfolio_data.dart';
import 'project_detail.dart';
import 'project_preview.dart';
import 'section_shell.dart';

/// Projects: filter pills + a responsive masonry-ish grid of project cards.
/// Tapping a card opens the full detail overlay.
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _filter = 'All';

  List<String> get _categories {
    final set = <String>{'All'};
    for (final p in PortfolioData.projects) {
      set.add(p.category);
    }
    return set.toList();
  }

  List<Project> get _visible {
    if (_filter == 'All') return PortfolioData.projects;
    return PortfolioData.projects.where((p) => p.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Projects',
            title: 'Selected ',
            titleAccent: 'work.',
            subtitle:
                'A few products I\'ve designed and engineered end-to-end. '
                'Tap any card for the full story.',
          ),
          const SizedBox(height: 32),
          RevealOnScroll(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in _categories)
                  _FilterPill(
                    label: c,
                    active: _filter == c,
                    onTap: () => setState(() => _filter = c),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _Grid(projects: _visible),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.projects});
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.value(context, mobile: 1, tablet: 2, desktop: 3);
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 22.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < projects.length; i++)
              SizedBox(
                width: width,
                child: RevealOnScroll(
                  key: ValueKey(projects[i].id),
                  delay: Duration(milliseconds: (i % 3) * 90),
                  child: _ProjectCard(project: projects[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      hoverBorder: project.accent.first,
      onTap: () => showProjectDetail(context, project),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ProjectPreview(project: project, height: 168, compact: true),
              if (project.featured)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: AppSpace.pill,
                      color: Colors.black.withValues(alpha: 0.45),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          'Featured',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      project.year,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: palette.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  project.tagline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final t in project.tech.take(3))
                            _TechDot(label: t),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_outward_rounded,
                        size: 17, color: palette.textTertiary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechDot extends StatelessWidget {
  const _TechDot({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11.5,
        color: palette.textTertiary,
      ),
    );
  }
}

class _FilterPill extends StatefulWidget {
  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_FilterPill> createState() => _FilterPillState();
}

class _FilterPillState extends State<_FilterPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppSpace.fast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: AppSpace.pill,
            gradient: widget.active ? app.gradient() : null,
            color: widget.active
                ? null
                : (_hover ? palette.surface2 : palette.glass),
            border: Border.all(
              color: widget.active
                  ? Colors.transparent
                  : (_hover ? palette.borderStrong : palette.border),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: widget.active ? Colors.white : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
