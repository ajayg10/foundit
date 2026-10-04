import 'package:flutter/material.dart';

/// Light and dark color palettes as compile-time constants.
/// Do NOT use these directly in widgets — use AppSemantic via the theme extension.
abstract final class AppColorsLight {
  static const bg = Color(0xFFEEF1F0);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF101820);
  static const muted = Color(0xFF5C6870);
  static const line = Color(0xFFDCE2E2);
  static const brand = Color(0xFF0E3B43);
  static const onBrand = Color(0xFFEAF3F2);
  static const onBrandMuted = Color(0xFF9FC1C5);
  static const lost = Color(0xFFB3263E);
  static const lostSoft = Color(0xFFF7E6E9);
  static const found = Color(0xFF0B7A66);
  static const foundSoft = Color(0xFFDFF1EC);

  // Semantic utility colours
  static const success = Color(0xFF0B7A66); // same as found
  static const warning = Color(0xFFA05C00);
  static const warningSoft = Color(0xFFFFF3D9);
  static const error = Color(0xFF8B1C2E); // darker than lost to differentiate
  static const errorSoft = Color(0xFFFAE4E8);
}

abstract final class AppColorsDark {
  static const bg = Color(0xFF0B1114);
  static const surface = Color(0xFF131B1F);
  static const ink = Color(0xFFE8EDEE);
  static const muted = Color(0xFF8D9AA1);
  static const line = Color(0xFF233036);
  static const brand = Color(0xFF1A4A53);
  static const onBrand = Color(0xFFEAF3F2);
  static const onBrandMuted = Color(0xFF9FC1C5);
  static const lost = Color(0xFFEE7387);
  static const lostSoft = Color(0xFF2A171C);
  static const found = Color(0xFF4FC7AB);
  static const foundSoft = Color(0xFF10261F);

  // Semantic utility colours
  static const success = Color(0xFF4FC7AB); // same as found
  static const warning = Color(0xFFFBBC04);
  static const warningSoft = Color(0xFF2A1F00);
  static const error = Color(0xFFFF8F9E); // lighter than lost for dark bg
  static const errorSoft = Color(0xFF32141A);
}
