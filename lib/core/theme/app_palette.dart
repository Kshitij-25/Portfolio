import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A [ThemeExtension] that carries the portfolio's surface/text/border tokens
/// so widgets can read semantic colours via `context.palette` and they animate
/// smoothly when the theme toggles.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.bg2,
    required this.surface,
    required this.surface2,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderStrong,
    required this.glass,
    required this.gridLine,
    required this.haloOpacity,
  });

  final Color bg;
  final Color bg2;
  final Color surface;
  final Color surface2;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color borderStrong;
  final Color glass;
  final Color gridLine;
  final double haloOpacity;

  static const dark = AppPalette(
    bg: AppColors.darkBg,
    bg2: AppColors.darkBg2,
    surface: AppColors.darkSurface,
    surface2: AppColors.darkSurface2,
    textPrimary: AppColors.darkText,
    textSecondary: AppColors.darkText2,
    textTertiary: AppColors.darkText3,
    border: AppColors.darkBorder,
    borderStrong: AppColors.darkBorderStrong,
    glass: AppColors.darkGlass,
    gridLine: Color(0x09FFFFFF),
    haloOpacity: 0.55,
  );

  static const light = AppPalette(
    bg: AppColors.lightBg,
    bg2: AppColors.lightBg2,
    surface: AppColors.lightSurface,
    surface2: AppColors.lightSurface2,
    textPrimary: AppColors.lightText,
    textSecondary: AppColors.lightText2,
    textTertiary: AppColors.lightText3,
    border: AppColors.lightBorder,
    borderStrong: AppColors.lightBorderStrong,
    glass: AppColors.lightGlass,
    gridLine: Color(0x0A0F121E),
    haloOpacity: 0.32,
  );

  @override
  AppPalette copyWith({
    Color? bg,
    Color? bg2,
    Color? surface,
    Color? surface2,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? borderStrong,
    Color? glass,
    Color? gridLine,
    double? haloOpacity,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      glass: glass ?? this.glass,
      gridLine: gridLine ?? this.gridLine,
      haloOpacity: haloOpacity ?? this.haloOpacity,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      haloOpacity: haloOpacity + (other.haloOpacity - haloOpacity) * t,
    );
  }
}

/// Sugar: `context.palette.surface`, `context.palette.textSecondary`, etc.
extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
