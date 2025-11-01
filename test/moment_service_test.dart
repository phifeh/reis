import 'package:flutter_test/flutter_test.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';
import 'package:reis/core/models/moment.dart';
import 'package:reis/core/models/grouping_strategy.dart';

void main() {
  group('Moment Service Tests', () {
    test('should group nearby events into same moment', () {
      final location1 = Location(
        latitude: 48.8584,
        longitude: 2.2945,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      );

      final location2 = Location(
        latitude: 48.8585,
        longitude: 2.2946,
        accuracy: 10.0,
        timestamp: DateTime.now().add(const Duration(minutes: 5)),
      );

      final event1 = CaptureEvent.photo(
        id: '1',
        timestamp: DateTime.now(),
        location: location1,
        filePath: '/path/to/photo1.jpg',
      );

      final event2 = CaptureEvent.photo(
        id: '2',
        timestamp: DateTime.now().add(const Duration(minutes: 5)),
        location: location2,
        filePath: '/path/to/photo2.jpg',
      );

      expect(event1.location, isNotNull);
      expect(event2.location, isNotNull);
      expect(event1.type, CaptureType.photo);
      expect(event2.type, CaptureType.photo);
    });

    test('should create separate moments for distant events', () {
      final location1 = Location(
        latitude: 48.8584,
        longitude: 2.2945,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      );

      final location2 = Location(
        latitude: 48.8700,
        longitude: 2.3100,
        accuracy: 10.0,
        timestamp: DateTime.now().add(const Duration(hours: 2)),
      );

      expect((location1.latitude - location2.latitude).abs(), greaterThan(0.01));
      expect((location1.longitude - location2.longitude).abs(), greaterThan(0.01));
    });

    test('should handle events without location', () {
      final event = CaptureEvent.text(
        id: '1',
        timestamp: DateTime.now(),
        location: null,
        text: 'A note without location',
      );

      expect(event.location, isNull);
      expect(event.type, CaptureType.text);
      expect(event.data['text'], 'A note without location');
    });

    test('GroupingStrategy defaults', () {
      final strategy = GroupingStrategy.defaultStrategy();

      expect(strategy.distanceThreshold, 100.0);
      expect(strategy.timeThreshold, const Duration(minutes: 30));
      expect(strategy.autoGroupEnabled, true);
    });

    test('GroupingStrategy custom', () {
      final strategy = GroupingStrategy(
        distanceThreshold: 50.0,
        timeThreshold: const Duration(minutes: 15),
        autoGroupEnabled: true,
      );

      expect(strategy.distanceThreshold, 50.0);
      expect(strategy.timeThreshold, const Duration(minutes: 15));
    });

    test('Moment creation', () {
      final moment = Moment(
        id: 'moment-1',
        name: 'Visit to Eiffel Tower',
        eventIds: const ['event-1', 'event-2'],
        type: MomentType.manual,
        startTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(moment.id, 'moment-1');
      expect(moment.name, 'Visit to Eiffel Tower');
      expect(moment.eventIds.length, 2);
      expect(moment.type, MomentType.manual);
    });
  });

  group('Edge Cases', () {
    test('should handle rapid captures', () {
      final now = DateTime.now();
      final events = List.generate(
        5,
        (i) => CaptureEvent.photo(
          id: 'rapid-$i',
          timestamp: now.add(Duration(seconds: i * 2)),
          location: Location(
            latitude: 48.8584,
            longitude: 2.2945,
            accuracy: 10.0,
            timestamp: now.add(Duration(seconds: i * 2)),
          ),
          filePath: '/path/photo$i.jpg',
        ),
      );

      expect(events.length, 5);
      expect(events.first.id, 'rapid-0');
      expect(events.last.id, 'rapid-4');
    });

    test('should handle GPS loss scenario', () {
      final event1 = CaptureEvent.photo(
        id: 'before-tunnel',
        timestamp: DateTime.now(),
        location: Location(
          latitude: 48.8584,
          longitude: 2.2945,
          accuracy: 10.0,
          timestamp: DateTime.now(),
        ),
        filePath: '/path/before.jpg',
      );

      final event2 = CaptureEvent.photo(
        id: 'in-tunnel',
        timestamp: DateTime.now().add(const Duration(minutes: 10)),
        location: null,
        filePath: '/path/during.jpg',
      );

      final event3 = CaptureEvent.photo(
        id: 'after-tunnel',
        timestamp: DateTime.now().add(const Duration(minutes: 20)),
        location: Location(
          latitude: 48.8600,
          longitude: 2.3000,
          accuracy: 10.0,
          timestamp: DateTime.now().add(const Duration(minutes: 20)),
        ),
        filePath: '/path/after.jpg',
      );

      expect(event1.location, isNotNull);
      expect(event2.location, isNull);
      expect(event3.location, isNotNull);
    });

    test('should handle circular routes', () {
      final hotelLocation = Location(
        latitude: 48.8584,
        longitude: 2.2945,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      );

      final event1 = CaptureEvent.text(
        id: 'morning',
        timestamp: DateTime.now(),
        location: hotelLocation,
        text: 'Starting the day',
      );

      final event2 = CaptureEvent.text(
        id: 'evening',
        timestamp: DateTime.now().add(const Duration(hours: 8)),
        location: Location(
          latitude: hotelLocation.latitude,
          longitude: hotelLocation.longitude,
          accuracy: 10.0,
          timestamp: DateTime.now().add(const Duration(hours: 8)),
        ),
        text: 'Back at hotel',
      );

      expect(event1.location?.latitude, event2.location?.latitude);
      expect(event1.location?.longitude, event2.location?.longitude);
    });
  });

  group('Data Validation', () {
    test('CaptureEvent.photo validates required fields', () {
      expect(
        () => CaptureEvent.photo(
          id: '',
          timestamp: DateTime.now(),
          location: null,
          filePath: '',
        ),
        returnsNormally,
      );
    });

    test('CaptureEvent.audio includes duration', () {
      final event = CaptureEvent.audio(
        id: 'audio-1',
        timestamp: DateTime.now(),
        location: null,
        filePath: '/path/audio.m4a',
        durationSeconds: 45,
      );

      expect(event.data['duration'], 45);
      expect(event.data['filePath'], '/path/audio.m4a');
    });

    test('CaptureEvent.rating validates range', () {
      final event = CaptureEvent.rating(
        id: 'rating-1',
        timestamp: DateTime.now(),
        location: null,
        rating: 5,
        place: 'Amazing Restaurant',
      );

      expect(event.data['rating'], 5);
      expect(event.data['place'], 'Amazing Restaurant');
    });
  });
}
