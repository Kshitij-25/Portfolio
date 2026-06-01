import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../responsive/responsive.dart';
import '../state/app_scope.dart';
import '../theme/app_palette.dart';
import 'gradient_text.dart';
import 'reveal_on_scroll.dart';

/// Eyebrow + headline + optional subtitle block used at the top of sections
/// (matches `.eyebrow`, `.section-title`, `.section-sub`).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.titleAccent,
    this.subtitle,
    this.center = false,
  });

  final String eyebrow;
  final String title;
  final String? titleAccent;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final app = AppScope.of(context);
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    final titleSize = Responsive.value(context, mobile: 30.0, tablet: 38.0, desktop: 46.0);

    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: align,
        children: [
          // eyebrow
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 22, height: 1, color: app.accentA.withValues(alpha: 0.7)),
              const SizedBox(width: 9),
              Text(
                eyebrow.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.5,
                  letterSpacing: 2,
                  color: app.accentA,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // title (with optional gradient accent fragment)
          DefaultTextStyle.merge(
            textAlign: textAlign,
            style: GoogleFonts.spaceGrotesk(
              fontSize: titleSize,
              height: 1.05,
              letterSpacing: -titleSize * 0.03,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
            child: Wrap(
              alignment: center ? WrapAlignment.center : WrapAlignment.start,
              children: [
                Text(title),
                if (titleAccent != null)
                  GradientText(
                    titleAccent!,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: titleSize,
                      height: 1.05,
                      letterSpacing: -titleSize * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                subtitle!,
                textAlign: textAlign,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: Responsive.value(context, mobile: 15.0, desktop: 17.0),
                  height: 1.6,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
