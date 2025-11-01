// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaptureEventImpl _$$CaptureEventImplFromJson(Map<String, dynamic> json) =>
    _$CaptureEventImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      data: json['data'] as Map<String, dynamic>,
      type: $enumDecode(_$CaptureTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$CaptureEventImplToJson(_$CaptureEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'location': instance.location,
      'data': instance.data,
      'type': _$CaptureTypeEnumMap[instance.type]!,
    };

const _$CaptureTypeEnumMap = {
  CaptureType.photo: 'photo',
  CaptureType.audio: 'audio',
  CaptureType.text: 'text',
  CaptureType.rating: 'rating',
  CaptureType.imported: 'imported',
};
