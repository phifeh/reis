import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouping_strategy.freezed.dart';
part 'grouping_strategy.g.dart';

@freezed
class GroupingStrategy with _$GroupingStrategy {
  const factory GroupingStrategy({
    required Duration timeThreshold,
    required double distanceThreshold,
    @Default(3) int minEventsForMoment,
    @Default(true) bool autoGroupEnabled,
  }) = _GroupingStrategy;

  factory GroupingStrategy.fromJson(Map<String, dynamic> json) =>
      _$GroupingStrategyFromJson(json);

  factory GroupingStrategy.defaultStrategy() => const GroupingStrategy(
        timeThreshold: Duration(minutes: 30),
        distanceThreshold: 100.0,
      );
}
