import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../data/models.dart';

/// Stylised, gradient app-preview tile used as a project's "screenshot".
/// Avoids shipping image assets while still looking like a real product shot.
class ProjectPreview extends StatelessWidget {
  const ProjectPreview({
    super.key,
    required this.project,
    this.height = 200,
    this.compact = false,
  });

  final Project project;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpace.br,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              project.accent.first.withValues(alpha: 0.9),
              project.accent.last.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Stack(
          children: [
            // soft inner glow
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
            // faux app card floating
            Align(
              alignment: const Alignment(0, 0.5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: compact ? 22 : 34),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: AppSpace.br,
                  color: const Color(0xFF0B0D14).withValues(alpha: 0.78),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flutter_dash,
                            size: 16, color: Colors.white.withValues(alpha: 0.9)),
                        const SizedBox(width: 8),
                        Text(
                          project.category,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _bar(0.9, Colors.white.withValues(alpha: 0.85)),
                    const SizedBox(height: 7),
                    _bar(0.6, Colors.white.withValues(alpha: 0.4)),
                    if (!compact) ...[
                      const SizedBox(height: 7),
                      _bar(0.75, Colors.white.withValues(alpha: 0.4)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double w, Color c) {
    return FractionallySizedBox(
      widthFactor: w,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: c,
        ),
      ),
    );
  }
}
