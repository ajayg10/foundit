import 'dart:math';

/// Service to calculate geographic distance between coordinates using the Haversine formula
/// and evaluate a geographic similarity score (0.0 to 1.0).
class DistanceService {
  /// Earth's radius in kilometers
  static const double earthRadiusKm = 6371.0;

  /// Calculates the great-circle distance between two points in kilometers.
  static double calculateDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Converts a physical distance in km into a confidence score (0.0 to 1.0).
  /// College campuses & office buildings are localized:
  /// - 0 - 0.2 km -> 1.00
  /// - 0.5 km     -> 0.95
  /// - 1.0 km     -> 0.85
  /// - 2.0 km     -> 0.70
  /// - 5.0 km     -> 0.50
  /// - 10.0 km    -> 0.30
  /// - 20.0 km    -> 0.10
  /// - > 20 km    -> 0.02
  static double calculateDistanceScore(double distanceKm) {
    if (distanceKm <= 0.2) return 1.0;
    if (distanceKm <= 0.5) return 0.95;
    if (distanceKm <= 1.0) return 0.85 - (distanceKm - 0.5) * 0.2;
    if (distanceKm <= 2.0) return 0.75 - (distanceKm - 1.0) * 0.15;
    if (distanceKm <= 5.0) return 0.60 - (distanceKm - 2.0) * 0.066;
    if (distanceKm <= 10.0) return 0.40 - (distanceKm - 5.0) * 0.03;
    if (distanceKm <= 20.0) return 0.25 - (distanceKm - 10.0) * 0.015;
    return max(0.01, 0.10 - (distanceKm - 20.0) * 0.005);
  }

  static double _toRadians(double degrees) => degrees * pi / 180.0;
}
