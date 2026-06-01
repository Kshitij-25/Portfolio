import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system.
/// Display: Space Grotesk · Body: Plus Jakarta Sans · Mono: JetBrains Mono
/// (matches the design system declared in styles.css).
class AppType {
  AppType._();

  static TextStyle display(Color color) => GoogleFonts.spaceGrotesk(
        color: color,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.03 * 16,
      );

  static TextStyle body(Color color) => GoogleFonts.plusJakartaSans(
        color: color,
        fontWeight: FontWeight.w400,
        height: 1.55,
      );

  static TextStyle mono(Color color) => GoogleFonts.jetBrainsMono(
        color: color,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      );

  /// Builds a full Material [TextTheme] from the body font, used as the base
  /// text theme. Display-specific styles are applied per-widget.
  static TextTheme textTheme(Color color) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.apply(
      bodyColor: color,
      displayColor: color,
    );
  }
}
