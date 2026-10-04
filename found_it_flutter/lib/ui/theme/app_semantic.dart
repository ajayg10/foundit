import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ThemeExtension that carries semantic design tokens into widget trees.
/// Access via: `Theme.of(context).extension<AppSemantic>()!`
/// Or via the context extension: `context.colors`
class AppSemantic extends ThemeExtension<AppSemantic> {
  const AppSemantic({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.brand,
    required this.onBrand,
    required this.onBrandMuted,
    required this.lost,
    required this.lostSoft,
    required this.found,
    required this.foundSoft,
    required this.success,
    required this.warning,
    required this.warningSoft,
    required this.error,
    required this.errorSoft,
  });

  final Color bg;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color brand;
  final Color onBrand;
  final Color onBrandMuted;
  final Color lost;
  final Color lostSoft;
  final Color found;
  final Color foundSoft;
  final Color success;
  final Color warning;
  final Color warningSoft;
  final Color error;
  final Color errorSoft;

  // ── Pre-built instances ───────────────────────────────────────────────

  static const light = AppSemantic(
    bg: AppColorsLight.bg,
    surface: AppColorsLight.surface,
    ink: AppColorsLight.ink,
    muted: AppColorsLight.muted,
    line: AppColorsLight.line,
    brand: AppColorsLight.brand,
    onBrand: AppColorsLight.onBrand,
    onBrandMuted: AppColorsLight.onBrandMuted,
    lost: AppColorsLight.lost,
    lostSoft: AppColorsLight.lostSoft,
    found: AppColorsLight.found,
    foundSoft: AppColorsLight.foundSoft,
    success: AppColorsLight.success,
    warning: AppColorsLight.warning,
    warningSoft: AppColorsLight.warningSoft,
    error: AppColorsLight.error,
    errorSoft: AppColorsLight.errorSoft,
  );

  static const dark = AppSemantic(
    bg: AppColorsDark.bg,
    surface: AppColorsDark.surface,
    ink: AppColorsDark.ink,
    muted: AppColorsDark.muted,
    line: AppColorsDark.line,
    brand: AppColorsDark.brand,
    onBrand: AppColorsDark.onBrand,
    onBrandMuted: AppColorsDark.onBrandMuted,
    lost: AppColorsDark.lost,
    lostSoft: AppColorsDark.lostSoft,
    found: AppColorsDark.found,
    foundSoft: AppColorsDark.foundSoft,
    success: AppColorsDark.success,
    warning: AppColorsDark.warning,
    warningSoft: AppColorsDark.warningSoft,
    error: AppColorsDark.error,
    errorSoft: AppColorsDark.errorSoft,
  );

  // ── ThemeExtension boilerplate ────────────────────────────────────────

  @override
  AppSemantic copyWith({
    Color? bg,
    Color? surface,
    Color? ink,
    Color? muted,
    Color? line,
    Color? brand,
    Color? onBrand,
    Color? onBrandMuted,
    Color? lost,
    Color? lostSoft,
    Color? found,
    Color? foundSoft,
    Color? success,
    Color? warning,
    Color? warningSoft,
    Color? error,
    Color? errorSoft,
  }) {
    return AppSemantic(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      onBrandMuted: onBrandMuted ?? this.onBrandMuted,
      lost: lost ?? this.lost,
      lostSoft: lostSoft ?? this.lostSoft,
      found: found ?? this.found,
      foundSoft: foundSoft ?? this.foundSoft,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      error: error ?? this.error,
      errorSoft: errorSoft ?? this.errorSoft,
    );
  }

  @override
  AppSemantic lerp(AppSemantic? other, double t) {
    if (other == null) return this;
    return AppSemantic(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      onBrandMuted: Color.lerp(onBrandMuted, other.onBrandMuted, t)!,
      lost: Color.lerp(lost, other.lost, t)!,
      lostSoft: Color.lerp(lostSoft, other.lostSoft, t)!,
      found: Color.lerp(found, other.found, t)!,
      foundSoft: Color.lerp(foundSoft, other.foundSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorSoft: Color.lerp(errorSoft, other.errorSoft, t)!,
    );
  }
}

/// Context extension for ergonomic access to semantic colors and text.
extension AppSemanticX on BuildContext {
  AppSemantic get colors => Theme.of(this).extension<AppSemantic>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
