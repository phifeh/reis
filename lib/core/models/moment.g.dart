// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MomentImpl _$$MomentImplFromJson(Map<String, dynamic> json) => _$MomentImpl(
  id: json['id'] as String,
  name: json['name'] as String?,
  eventIds: (json['eventIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  type: $enumDecode(_$MomentTypeEnumMap, json['type']),
  parentMomentId: json['parentMomentId'] as String?,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  centerLat: (json['centerLat'] as num?)?.toDouble(),
  centerLon: (json['centerLon'] as num?)?.toDouble(),
  radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 100.0,
  eventCount: (json['eventCount'] as num?)?.toInt() ?? 0,
  settings: json['settings'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$MomentImplToJson(_$MomentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'eventIds': instance.eventIds,
      'type': _$MomentTypeEnumMap[instance.type]!,
      'parentMomentId': instance.parentMomentId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'centerLat': instance.centerLat,
      'centerLon': instance.centerLon,
      'radiusMeters': instance.radiusMeters,
      'eventCount': instance.eventCount,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MomentTypeEnumMap = {
  MomentType.auto: 'auto',
  MomentType.manual: 'manual',
  MomentType.journey: 'journey',
};
