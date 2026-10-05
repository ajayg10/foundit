import 'package:flutter/material.dart';

/// 4-pt spacing scale, radii constants, and named gaps.
abstract final class AppSpacing {
  // ── Scale ─────────────────────────────────────────────────────────────
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;

  // ── Screen horizontal padding ─────────────────────────────────────────
  static const double screenH = 20;

  // ── Named SizedBox gaps ───────────────────────────────────────────────
  static const gap4 = SizedBox(height: s4);
  static const gap8 = SizedBox(height: s8);
  static const gap12 = SizedBox(height: s12);
  static const gap16 = SizedBox(height: s16);
  static const gap20 = SizedBox(height: s20);
  static const gap24 = SizedBox(height: s24);
  static const gap32 = SizedBox(height: s32);
  static const gap40 = SizedBox(height: s40);

  static const hGap4 = SizedBox(width: s4);
  static const hGap8 = SizedBox(width: s8);
  static const hGap12 = SizedBox(width: s12);
  static const hGap16 = SizedBox(width: s16);
  static const hGap20 = SizedBox(width: s20);

  // ── EdgeInsets helpers ────────────────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenH,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(s16);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: s12,
  );
}

/// Border radius constants.
abstract final class AppRadius {
  static const double pill = 999;
  static const double button = 14;
  static const double tile = 18;
  static const double panel = 20;
  static const double sheet = 22;
  static const double ticket = 22;

  static const BorderRadius pillBr = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius buttonBr = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius tileBr = BorderRadius.all(Radius.circular(tile));
  static const BorderRadius panelBr = BorderRadius.all(Radius.circular(panel));
  static const BorderRadius sheetBr = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
  static const BorderRadius ticketBr = BorderRadius.all(
    Radius.circular(ticket),
  );
}
