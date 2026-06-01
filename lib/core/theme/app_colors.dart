import 'package:flutter/material.dart';

/// Raw colour tokens, ported 1:1 from the approved design system
/// (see styles.css `:root`, `[data-theme="dark"]`, `[data-theme="light"]`).
class AppColors {
  AppColors._();

  // ---------- DARK ----------
  static const darkBg = Color(0xFF07080C);
  static const darkBg2 = Color(0xFF0A0C12);
  static const darkSurface = Color(0xFF0F1118);
  static const darkSurface2 = Color(0xFF14161F);
  static const darkText = Color(0xFFF3F4F8);
  static const darkText2 = Color(0xFFA4A8B6);
  static const darkText3 = Color(0xFF6A6E7E);
  static const darkBorder = Color(0x14FFFFFF); // white @ ~8%
  static const darkBorderStrong = Color(0x24FFFFFF); // white @ ~14%
  static const darkGlass = Color(0x09FFFFFF); // white @ ~3.5%

  // ---------- LIGHT ----------
  static const lightBg = Color(0xFFF6F7FB);
  static const lightBg2 = Color(0xFFEEF0F6);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF4F5F9);
  static const lightText = Color(0xFF0D0F17);
  static const lightText2 = Color(0xFF4A4F5E);
  static const lightText3 = Color(0xFF878C9B);
  static const lightBorder = Color(0x170F121E); // ink @ ~9%
  static const lightBorderStrong = Color(0x290F121E); // ink @ ~16%
  static const lightGlass = Color(0xB3FFFFFF); // white @ ~70%
}
