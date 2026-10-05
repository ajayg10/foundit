import 'package:flutter/material.dart';

/// Screen width breakpoints for responsive layout.
abstract final class Breakpoints {
  /// Single-column phone layout.
  static const double compact = 600;

  /// Two-column tablet / large phone landscape layout.
  static const double medium = 840;

  static bool isCompact(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < compact;

  static bool isMedium(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= compact && w < medium;
  }

  static bool isExpanded(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= medium;
}
