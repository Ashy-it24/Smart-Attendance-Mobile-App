import 'dart:math' as math;

class LocationUtils {
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;

    // Convert degrees to radians
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    // Haversine formula
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    final double distanceKm = earthRadiusKm * c;

    // Convert to meters
    return distanceKm * 1000;
  }

  /// Check if a location is within a specified radius
  static bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double centerLat,
    required double centerLon,
    required double radiusInMeters,
  }) {
    final double distance = calculateDistance(
      lat1: userLat,
      lon1: userLon,
      lat2: centerLat,
      lon2: centerLon,
    );
    return distance <= radiusInMeters;
  }

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
}
