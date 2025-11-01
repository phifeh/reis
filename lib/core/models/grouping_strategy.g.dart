// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouping_strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupingStrategyImpl _$$GroupingStrategyImplFromJson(
  Map<String, dynamic> json,
) => _$GroupingStrategyImpl(
  timeThreshold: Duration(microseconds: (json['timeThreshold'] as num).toInt()),
  distanceThreshold: (json['distanceThreshold'] as num).toDouble(),
  minEventsForMoment: (json['minEventsForMoment'] as num?)?.toInt() ?? 3,
  autoGroupEnabled: json['autoGroupEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$GroupingStrategyImplToJson(
  _$GroupingStrategyImpl instance,
) => <String, dynamic>{
  'timeThreshold': instance.timeThreshold.inMicroseconds,
  'distanceThreshold': instance.distanceThreshold,
  'minEventsForMoment': instance.minEventsForMoment,
  'autoGroupEnabled': instance.autoGroupEnabled,
};
