import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/chip_tag.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models.dart';
import 'project_preview.dart';

/// Full project detail shown as a bottom-anchored sheet / centered modal with
/// preview, full description, metrics and action buttons.
Future<void> showProjectDetail(BuildContext context, Project project) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: project.title,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _ProjectDetail(project: project),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppSpace.easeOut);
      return Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * 40),
          child: Transform.scale(
            scale: 0.96 + curved.value * 0.04,
            child: child,
          ),
        ),
      );
    },
  );
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({required this.project});
  final Project project;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, maxHeight: 760),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppSpace.brXl,
                color: palette.surface,
                border: Border.all(color: palette.borderStrong),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 80,
                    offset: const Offset(0, 40),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ProjectPreview(project: project, height: 240),
                        Positioned(
                          top: 14,
                          right: 14,
                          child: _CloseButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                project.category,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                  color: project.accent.first,
                                ),
                              ),
                              Text(
                                '  ·  ${project.year}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                  color: palette.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            project.title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            project.tagline,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            project.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.5,
                              height: 1.7,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // metrics
                          Row(
                            children: [
                              for (final m in project.metrics) ...[
                                _Metric(metric: m),
                                const SizedBox(width: 14),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final t in project.tech) ChipTag(t),
                            ],
                          ),
                          if (project.demo != null || project.repo != null) ...[
                            const SizedBox(height: 28),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                if (project.demo != null)
                                  GradientButton(
                                    label: 'Live Demo',
                                    trailing: Icons.open_in_new_rounded,
                                    onPressed: () => _open(project.demo!),
                                  ),
                                if (project.repo != null)
                                  GradientButton(
                                    label: 'View Code',
                                    variant: BtnVariant.ghost,
                                    leading: Icons.code_rounded,
                                    onPressed: () => _open(project.repo!),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.metric});
  final Metric metric;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.v,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          metric.k,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: palette.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppSpace.fast,
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: _hover ? 0.55 : 0.4),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
