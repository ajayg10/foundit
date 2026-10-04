import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale for Found It.
/// Uses:
///   Display / heading: Bricolage Grotesque
///   Body / UI: Hanken Grotesk
abstract final class AppText {
  // ── Display numerals ─────────────────────────────────────────────────
  static TextStyle display(Color ink) => GoogleFonts.bricolageGrotesque(
    fontSize: 56,
    height: 1.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.03 * 56,
    color: ink,
  );

  // ── Headings ─────────────────────────────────────────────────────────
  static TextStyle h1(Color ink) => GoogleFonts.bricolageGrotesque(
    fontSize: 28,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 28,
    color: ink,
  );

  static TextStyle h2(Color ink) => GoogleFonts.bricolageGrotesque(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 22,
    color: ink,
  );

  static TextStyle h3(Color ink) => GoogleFonts.bricolageGrotesque(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01 * 18,
    color: ink,
  );

  // ── Large numeral (stat tiles) ────────────────────────────────────────
  static TextStyle numeral(Color ink) => GoogleFonts.bricolageGrotesque(
    fontSize: 34,
    height: 1.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.03 * 34,
    color: ink,
  );

  // ── Body ─────────────────────────────────────────────────────────────
  static TextStyle bodyL(Color ink) => GoogleFonts.hankenGrotesk(
    fontSize: 16,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: ink,
  );

  static TextStyle body(Color ink) => GoogleFonts.hankenGrotesk(
    fontSize: 14,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: ink,
  );

  static TextStyle label(Color ink) => GoogleFonts.hankenGrotesk(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: ink,
  );

  static TextStyle caption(Color ink) => GoogleFonts.hankenGrotesk(
    fontSize: 12.5,
    height: 1.35,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: ink,
  );

  // ── Helper: build a full TextTheme for ThemeData ─────────────────────
  static TextTheme buildTextTheme(Color ink, Color muted) {
    return TextTheme(
      displayLarge: display(ink),
      displayMedium: h1(ink),
      displaySmall: h2(ink),
      headlineLarge: h1(ink),
      headlineMedium: h2(ink),
      headlineSmall: h3(ink),
      titleLarge: h3(ink),
      titleMedium: label(ink),
      titleSmall: caption(ink),
      bodyLarge: bodyL(ink),
      bodyMedium: body(ink),
      bodySmall: caption(muted),
      labelLarge: label(ink),
      labelMedium: label(muted),
      labelSmall: caption(muted),
    );
  }
}
