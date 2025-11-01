import 'dart:math' as math;
import 'package:reis/core/models/location.dart';

class LocationClustering {
  static double haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // meters

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  static ({double lat, double lon}) calculateCentroid(
    List<Location> locations, {
    List<double>? weights,
  }) {
    if (locations.isEmpty) {
      throw ArgumentError('Cannot calculate centroid of empty list');
    }

    if (weights != null && weights.length != locations.length) {
      throw ArgumentError('Weights must match locations length');
    }

    double totalWeight =
        weights?.reduce((a, b) => a + b) ?? locations.length.toDouble();
    double x = 0, y = 0, z = 0;

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];
      final weight = weights?[i] ?? 1.0;

      final lat = _toRadians(loc.latitude);
      final lon = _toRadians(loc.longitude);

      x += math.cos(lat) * math.cos(lon) * weight;
      y += math.cos(lat) * math.sin(lon) * weight;
      z += math.sin(lat) * weight;
    }

    x /= totalWeight;
    y /= totalWeight;
    z /= totalWeight;

    final centralLon = math.atan2(y, x);
    final centralSquareRoot = math.sqrt(x * x + y * y);
    final centralLat = math.atan2(z, centralSquareRoot);

    return (
      lat: centralLat * 180 / math.pi,
      lon: centralLon * 180 / math.pi,
    );
  }

  static double calculateRadius(
    List<Location> locations,
    double centerLat,
    double centerLon,
  ) {
    if (locations.isEmpty) return 0;

    double maxDistance = 0;
    for (final loc in locations) {
      final distance =
          haversineDistance(centerLat, centerLon, loc.latitude, loc.longitude);
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }
    return maxDistance;
  }

  static bool isIndoor(double? accuracy) {
    if (accuracy == null) return true;
    return accuracy > 50;
  }

  static bool isLikelyStationary(
    List<Location> recentLocations,
    Duration timeWindow,
  ) {
    if (recentLocations.length < 2) return false;

    final centroid = calculateCentroid(recentLocations);
    final radius = calculateRadius(
      recentLocations,
      centroid.lat,
      centroid.lon,
    );

    return radius < 50;
  }
}
