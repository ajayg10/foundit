import 'dart:math';

/// Service to calculate temporal closeness between reports and evaluate
/// a time similarity score (0.0 to 1.0).
class TimeService {
  /// Calculates the difference between two timestamps in hours.
  static double calculateDifferenceHours(DateTime t1, DateTime t2) {
    return (t1.difference(t2).inMinutes.abs()) / 60.0;
  }

  /// Converts a time difference in hours into a confidence score (0.0 to 1.0).
  /// - <= 2 hours -> 1.00
  /// - <= 6 hours -> 0.92
  /// - <= 12 hours -> 0.85
  /// - <= 24 hours (1 day) -> 0.75
  /// - <= 48 hours (2 days) -> 0.60
  /// - <= 168 hours (7 days) -> 0.40
  /// - <= 720 hours (30 days) -> 0.20
  /// - > 30 days -> 0.05
  static double calculateTimeScore(double hoursDiff) {
    if (hoursDiff <= 2.0) return 1.0;
    if (hoursDiff <= 6.0) return 0.95 - (hoursDiff - 2.0) * 0.025;
    if (hoursDiff <= 12.0) return 0.85 - (hoursDiff - 6.0) * 0.016;
    if (hoursDiff <= 24.0) return 0.75 - (hoursDiff - 12.0) * 0.0125;
    if (hoursDiff <= 48.0) return 0.60 - (hoursDiff - 24.0) * 0.006;
    if (hoursDiff <= 168.0) return 0.45 - (hoursDiff - 48.0) * 0.0016;
    return max(0.05, 0.25 - (hoursDiff - 168.0) * 0.0003);
  }
}
