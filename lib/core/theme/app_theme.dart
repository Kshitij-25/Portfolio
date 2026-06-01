import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_typography.dart';

/// Builds the Material 3 [ThemeData] for dark and light, wiring the colour
/// scheme, base text theme and the [AppPalette] extension.
class AppTheme {
  AppTheme._();

  static ThemeData dark(Color seed) => _build(
        brightness: Brightness.dark,
        seed: seed,
        scaffold: AppColors.darkBg,
        textColor: AppColors.darkText,
        palette: AppPalette.dark,
      );

  static ThemeData light(Color seed) => _build(
        brightness: Brightness.light,
        seed: seed,
        scaffold: AppColors.lightBg,
        textColor: AppColors.lightText,
        palette: AppPalette.light,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color seed,
    required Color scaffold,
    required Color textColor,
    required AppPalette palette,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ).copyWith(surface: scaffold);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: AppType.textTheme(textColor),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [palette],
    );
  }
}
