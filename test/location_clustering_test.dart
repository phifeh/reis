import 'package:flutter_test/flutter_test.dart';
import 'package:reis/core/algorithms/location_clustering.dart';
import 'package:reis/core/models/location.dart';

void main() {
  group('LocationClustering', () {
    test('haversineDistance calculates distance correctly', () {
      // Paris to London (approximately 344 km)
      final distance = LocationClustering.haversineDistance(
        48.8566, 2.3522, // Paris
        51.5074, -0.1278, // London
      );

      expect(distance, greaterThan(340000)); // ~344 km
      expect(distance, lessThan(350000));
    });

    test('haversineDistance for same location returns 0', () {
      final distance = LocationClustering.haversineDistance(
        48.8566, 2.3522,
        48.8566, 2.3522,
      );

      expect(distance, lessThan(1)); // Should be 0 or very close
    });

    test('haversineDistance for short distances', () {
      // 100m apart approximately
      final distance = LocationClustering.haversineDistance(
        48.8566, 2.3522,
        48.8576, 2.3522, // ~111m north
      );

      expect(distance, greaterThan(100));
      expect(distance, lessThan(150));
    });

    test('calculateCentroid for single location returns same location', () {
      final location = Location(
        latitude: 48.8566,
        longitude: 2.3522,
      );

      final centroid = LocationClustering.calculateCentroid([location]);

      expect(centroid.lat, closeTo(48.8566, 0.0001));
      expect(centroid.lon, closeTo(2.3522, 0.0001));
    });

    test('calculateCentroid for two locations returns midpoint', () {
      final loc1 = Location(latitude: 0, longitude: 0);
      final loc2 = Location(latitude: 10, longitude: 10);

      final centroid = LocationClustering.calculateCentroid([loc1, loc2]);

      expect(centroid.lat, closeTo(5, 0.5));
      expect(centroid.lon, closeTo(5, 0.5));
    });

    test('calculateCentroid with weights', () {
      final loc1 = Location(latitude: 0, longitude: 0);
      final loc2 = Location(latitude: 10, longitude: 10);

      // Weight loc2 more heavily
      final centroid = LocationClustering.calculateCentroid(
        [loc1, loc2],
        weights: [1, 3],
      );

      expect(centroid.lat, greaterThan(5)); // Should be closer to loc2
      expect(centroid.lon, greaterThan(5));
    });

    test('calculateRadius returns 0 for single location', () {
      final location = Location(latitude: 48.8566, longitude: 2.3522);

      final radius = LocationClustering.calculateRadius(
        [location],
        48.8566,
        2.3522,
      );

      expect(radius, lessThan(1));
    });

    test('calculateRadius returns max distance from center', () {
      final center = Location(latitude: 0, longitude: 0);
      final far = Location(latitude: 0.001, longitude: 0); // ~111m

      final radius = LocationClustering.calculateRadius(
        [center, far],
        0,
        0,
      );

      expect(radius, greaterThan(100));
      expect(radius, lessThan(150));
    });

    test('isIndoor returns true for poor accuracy', () {
      expect(LocationClustering.isIndoor(100), true);
      expect(LocationClustering.isIndoor(null), true);
    });

    test('isIndoor returns false for good accuracy', () {
      expect(LocationClustering.isIndoor(10), false);
      expect(LocationClustering.isIndoor(30), false);
    });

    test('isLikelyStationary returns false for insufficient data', () {
      final location = Location(latitude: 48.8566, longitude: 2.3522);

      final stationary = LocationClustering.isLikelyStationary(
        [location],
        const Duration(minutes: 5),
      );

      expect(stationary, false);
    });

    test('isLikelyStationary returns true for clustered locations', () {
      final locations = [
        Location(latitude: 48.8566, longitude: 2.3522),
        Location(latitude: 48.8567, longitude: 2.3522),
        Location(latitude: 48.8566, longitude: 2.3523),
      ];

      final stationary = LocationClustering.isLikelyStationary(
        locations,
        const Duration(minutes: 5),
      );

      expect(stationary, true);
    });
  });
}
