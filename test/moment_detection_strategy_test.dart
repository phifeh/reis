import 'package:flutter_test/flutter_test.dart';
import 'package:reis/core/models/moment_detection_strategy.dart';

void main() {
  group('MomentDetectionStrategy', () {
    test('defaultStrategy has correct values', () {
      final strategy = MomentDetectionStrategy.defaultStrategy();

      expect(strategy.distanceThreshold, 100.0);
      expect(strategy.timeThreshold, const Duration(minutes: 30));
      expect(strategy.autoCreateSubMoments, false);
      expect(strategy.subMomentDistanceThreshold, 30.0);
      expect(strategy.minEventsForMoment, 1);
    });

    test('strict strategy has tighter thresholds', () {
      final strategy = MomentDetectionStrategy.strict();

      expect(strategy.distanceThreshold, 50.0);
      expect(strategy.timeThreshold, const Duration(minutes: 15));
      expect(strategy.autoCreateSubMoments, true);
    });

    test('relaxed strategy has looser thresholds', () {
      final strategy = MomentDetectionStrategy.relaxed();

      expect(strategy.distanceThreshold, 200.0);
      expect(strategy.timeThreshold, const Duration(hours: 1));
      expect(strategy.autoCreateSubMoments, false);
    });

    test('custom strategy can be created', () {
      final strategy = MomentDetectionStrategy(
        distanceThreshold: 150.0,
        timeThreshold: const Duration(minutes: 45),
        autoCreateSubMoments: true,
        subMomentDistanceThreshold: 50.0,
        minEventsForMoment: 2,
      );

      expect(strategy.distanceThreshold, 150.0);
      expect(strategy.timeThreshold, const Duration(minutes: 45));
      expect(strategy.autoCreateSubMoments, true);
      expect(strategy.subMomentDistanceThreshold, 50.0);
      expect(strategy.minEventsForMoment, 2);
    });
  });

  group('MomentDecision', () {
    test('all decision types exist', () {
      expect(MomentDecision.createNew, isNotNull);
      expect(MomentDecision.addToExisting, isNotNull);
      expect(MomentDecision.createSubMoment, isNotNull);
      expect(MomentDecision.askUser, isNotNull);
    });
  });
}
