import 'package:flutter/material.dart';

/// Spacing, radii and motion tokens (ported from the CSS custom properties).
class AppSpace {
  AppSpace._();

  // radii
  static const double rSm = 10;
  static const double r = 16;
  static const double rLg = 24;
  static const double rXl = 32;

  static final BorderRadius brSm = BorderRadius.circular(rSm);
  static final BorderRadius br = BorderRadius.circular(r);
  static final BorderRadius brLg = BorderRadius.circular(rLg);
  static final BorderRadius brXl = BorderRadius.circular(rXl);
  static final BorderRadius pill = BorderRadius.circular(999);

  // section rhythm
  static const double sectionY = 120;
  static const double contentMax = 1180;
  static const double contentTight = 900;

  // motion
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration base = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);

  static const Curve ease = Cubic(0.22, 1, 0.36, 1);
  static const Curve easeOut = Cubic(0.16, 1, 0.3, 1);
}
