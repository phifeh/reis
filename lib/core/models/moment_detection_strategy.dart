enum MomentDecision {
  createNew,
  addToExisting,
  createSubMoment,
  askUser,
}

class MomentDetectionStrategy {
  final double distanceThreshold;
  final Duration timeThreshold;
  final bool autoCreateSubMoments;
  final double subMomentDistanceThreshold;
  final int minEventsForMoment;

  const MomentDetectionStrategy({
    this.distanceThreshold = 100.0,
    this.timeThreshold = const Duration(minutes: 30),
    this.autoCreateSubMoments = false,
    this.subMomentDistanceThreshold = 30.0,
    this.minEventsForMoment = 1,
  });

  factory MomentDetectionStrategy.defaultStrategy() {
    return const MomentDetectionStrategy();
  }

  factory MomentDetectionStrategy.strict() {
    return const MomentDetectionStrategy(
      distanceThreshold: 50.0,
      timeThreshold: Duration(minutes: 15),
      autoCreateSubMoments: true,
    );
  }

  factory MomentDetectionStrategy.relaxed() {
    return const MomentDetectionStrategy(
      distanceThreshold: 200.0,
      timeThreshold: Duration(hours: 1),
      autoCreateSubMoments: false,
    );
  }
}
