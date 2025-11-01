import 'package:flutter_test/flutter_test.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';

void main() {
  group('CaptureEvent', () {
    test('photo factory creates correct event', () {
      final now = DateTime.now();
      final location = Location(latitude: 48.8566, longitude: 2.3522);

      final event = CaptureEvent.photo(
        id: 'test-id',
        timestamp: now,
        location: location,
        filePath: '/path/to/photo.jpg',
        note: 'Test photo',
      );

      expect(event.id, 'test-id');
      expect(event.timestamp, now);
      expect(event.type, CaptureType.photo);
      expect(event.location, location);
      expect(event.data['filePath'], '/path/to/photo.jpg');
      expect(event.data['note'], 'Test photo');
    });

    test('photo factory without note', () {
      final event = CaptureEvent.photo(
        id: 'test-id',
        timestamp: DateTime.now(),
        filePath: '/path/to/photo.jpg',
      );

      expect(event.data['filePath'], '/path/to/photo.jpg');
      expect(event.data.containsKey('note'), false);
    });

    test('audio factory creates correct event', () {
      final event = CaptureEvent.audio(
        id: 'test-id',
        timestamp: DateTime.now(),
        filePath: '/path/to/audio.m4a',
        durationSeconds: 120,
        note: 'Test audio',
      );

      expect(event.type, CaptureType.audio);
      expect(event.data['filePath'], '/path/to/audio.m4a');
      expect(event.data['duration'], 120);
      expect(event.data['note'], 'Test audio');
    });

    test('text factory creates correct event', () {
      final event = CaptureEvent.text(
        id: 'test-id',
        timestamp: DateTime.now(),
        text: 'This is a test note',
      );

      expect(event.type, CaptureType.text);
      expect(event.data['text'], 'This is a test note');
    });

    test('rating factory creates correct event', () {
      final event = CaptureEvent.rating(
        id: 'test-id',
        timestamp: DateTime.now(),
        rating: 5,
        note: 'Great place',
      );

      expect(event.type, CaptureType.rating);
      expect(event.data['rating'], 5);
      expect(event.data['note'], 'Great place');
    });
  });

  group('CaptureType', () {
    test('all types exist', () {
      expect(CaptureType.photo, isNotNull);
      expect(CaptureType.audio, isNotNull);
      expect(CaptureType.text, isNotNull);
      expect(CaptureType.rating, isNotNull);
      expect(CaptureType.imported, isNotNull);
    });
  });

  group('Location', () {
    test('creates location with required fields', () {
      final location = Location(
        latitude: 48.8566,
        longitude: 2.3522,
      );

      expect(location.latitude, 48.8566);
      expect(location.longitude, 2.3522);
      expect(location.altitude, null);
      expect(location.accuracy, null);
      expect(location.timestamp, null);
    });

    test('creates location with all fields', () {
      final now = DateTime.now();
      final location = Location(
        latitude: 48.8566,
        longitude: 2.3522,
        altitude: 100.0,
        accuracy: 5.0,
        timestamp: now,
      );

      expect(location.latitude, 48.8566);
      expect(location.longitude, 2.3522);
      expect(location.altitude, 100.0);
      expect(location.accuracy, 5.0);
      expect(location.timestamp, now);
    });
  });
}
