import 'package:flutter_test/flutter_test.dart';
import 'package:reis/core/services/background_location_service.dart';

void main() {
  group('BackgroundLocationService Tests', () {
    late BackgroundLocationService service;

    setUp(() {
      service = BackgroundLocationService();
    });

    test('should be a singleton', () {
      final service1 = BackgroundLocationService();
      final service2 = BackgroundLocationService();

      expect(service1, same(service2));
    });

    test('should not be tracking initially', () {
      expect(service.isTracking, false);
    });

    test('should initialize successfully', () async {
      await service.initialize();
      expect(service, isNotNull);
    });

    test('should handle multiple initialize calls', () async {
      await service.initialize();
      await service.initialize();
      expect(service, isNotNull);
    });

    test('current location should be null initially', () {
      expect(service.currentLocation, isNull);
    });

    test('last position should be null initially', () {
      expect(service.lastPosition, isNull);
    });

    test('last location time should be null initially', () {
      expect(service.lastLocationTime, isNull);
    });
  });

  group('BackgroundLocationService State Management', () {
    test('should maintain singleton state', () {
      final service1 = BackgroundLocationService();
      final service2 = BackgroundLocationService();

      expect(service1.isTracking, service2.isTracking);
    });
  });
}
